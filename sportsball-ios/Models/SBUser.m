//
//  User.m
//  sportsball-ios
//
//  Created by Mike Silvis on 11/23/14.
//  Copyright (c) 2014 Mike Silvis. All rights reserved.
//

#import "SBUser.h"
#import "UIImage+FontAwesome.h"
#import <Underscore.h>
#import "SBConstants.h"
#import <Mixpanel.h>

// User Default Keys
static NSString *kLastOpenedLeague           = @"lastOpenedLeague1";
static NSString *kLastOpenedScoreOrStandings = @"LastOpenedScoreOrStandings";
static NSString *kAllLeagues                 = @"allLeagues-1";
static NSString *kAppOpens                   = @"appOpens";
static NSString *kAlreadyAskedForReview      = @"askedForReview";

static CGFloat const kAppOpensCountForNotification  = 5;

@interface SBUser ()

@property BOOL alreadyAskedForReview;
@property (nonatomic, copy) NSNumber *appOpens;

@end

@implementation SBUser

+ (SBUser *)currentUser {
  static SBUser *currentUser = nil;

  @synchronized(self) {
    if (currentUser == nil)
      currentUser = [[self alloc] init];
  }

  return currentUser;
}

- (id)init {
  self = [super init];

  if (self) {
    [PFUser enableAutomaticUser];

    self.currentPfUser = [PFUser currentUser];
    [[Mixpanel sharedInstance] identify:self.currentPfUser.objectId];

    if (self.currentPfUser.objectId) {
      [[PFUser currentUser] fetchInBackground];
    }

    NSString *currentTimeZone = [PFUser currentUser][@"timeZone"];
    if (!currentTimeZone || ![[[NSTimeZone localTimeZone] name] isEqualToString:currentTimeZone]) {
      [PFUser currentUser][@"timeZone"] = [[NSTimeZone localTimeZone] name];
      [[PFUser currentUser] saveInBackground];
    }

    [self setUserDefaults];
  }

  return self;
}

- (PTPusher *)client {
  if (!_client) {
    self.client = [PTPusher pusherWithKey:[[SBConstants sharedInstance] getSecretValueFrom:@"PUSHER_KEY"] delegate:self encrypted:YES];
    self.client.reconnectDelay = 3.0;
    [self.client connect];
  }
  
  return _client;
}
   
- (void)setLastOpenedLeagueIndex:(NSNumber *)lastOpenedLeagueIndex {
  _lastOpenedLeagueIndex = lastOpenedLeagueIndex;

  self.currentPfUser[@"lastOpenedLeague"] = self.lastOpenedLeagueIndex;

  [self syncUserDefaults];
}

- (SBLeague *)lastOpenedLeague {
  return self.leagues[[self.lastOpenedLeagueIndex intValue]];
}

- (void)setLeagues:(NSArray *)leagues {
  _leagues = leagues;

  [self syncUserDefaults];
}

- (void)setLastOpenedScoreOrStandings:(NSNumber *)lastOpenedScoreOrStandings {
  _lastOpenedScoreOrStandings = lastOpenedScoreOrStandings;

  [self syncUserDefaults];
}

- (void)appendFavoriteTeams:(SBTeam *)homeTeam andTeam:(SBTeam *)awayTeam andLeague:(NSString *)league {
  // Only if the opposite team is not favorable
  if (![awayTeam isFavorableTeam]) {
    [SBTeam incrementFavoriteTeam:homeTeam withSuccess:^(PFObject *object) {
      [self getFavoriteTeams:YES];
    }];
  }

  // Only if the opposite team is not favorable
  if (![homeTeam isFavorableTeam]) {
    [SBTeam incrementFavoriteTeam:awayTeam withSuccess:^(PFObject *object) {
      [self getFavoriteTeams:YES];
    }];
  }

}

- (NSString *)favoriteTeam:(SBLeague *)league {
  NSArray *filteredArray = Underscore.array(self.favoriteTeams).filter(^BOOL(PFObject *object) {
    return [object[@"league"] isEqualToString:league.name];
  }).unwrap;

  if (filteredArray) {
    return [filteredArray firstObject][@"teamDataName"];
  }

  return nil;
}

- (NSString *)networkConnectionErrorMessage:(NSError *)error {
  return @"No Network Connection";
}

- (UIImage *)networkConnectionErrorIcon {
  CGFloat iconSize = 32;
  FAKFontAwesome *warningIcon = [FAKFontAwesome warningIconWithSize:iconSize];

  return [UIImage imageWithFontAwesomeIcon:warningIcon andSize:iconSize andColor:@"#c4eefe"];
}

- (void)incrementAppOpens {
  self.appOpens = [NSNumber numberWithInt:[self.appOpens intValue] + 1];
    
  [self syncUserDefaults];
}

#pragma mark - Sync settings

- (void)syncUserDefaults {
  NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];

  [defaults setObject:self.lastOpenedLeagueIndex forKey:kLastOpenedLeague];
  [defaults setObject:self.lastOpenedScoreOrStandings forKey:kLastOpenedScoreOrStandings];
  [defaults setObject:self.appOpens forKey:kAppOpens];
  [defaults setObject:@(self.alreadyAskedForReview) forKey:kAlreadyAskedForReview];

  // Set Leagues
  NSMutableArray *encodedLeagues = [NSMutableArray array];
  for (SBLeague *league in self.leagues) {
    NSData *encodedNewLeague = [NSKeyedArchiver archivedDataWithRootObject:league];
    [encodedLeagues addObject:encodedNewLeague];
  }

  if (encodedLeagues.count > 0) {
    [defaults setObject:encodedLeagues forKey:kAllLeagues];
  }

  [defaults synchronize];

  [self.currentPfUser saveInBackground];
}

- (void)setUserDefaults {
  NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];

  _lastOpenedLeagueIndex = [defaults objectForKey:kLastOpenedLeague];
  _lastOpenedScoreOrStandings = [defaults objectForKey:kLastOpenedScoreOrStandings];
  if (!_lastOpenedLeagueIndex) {
    _lastOpenedLeagueIndex = [NSNumber numberWithInt:-1];
  }

  _appOpens = [defaults objectForKey:kAppOpens];
  _alreadyAskedForReview = [[defaults objectForKey:kAlreadyAskedForReview] boolValue];
  _favoriteTeams = @[];

  // Retrieve leagues
  NSArray *encodedLeagues = [defaults objectForKey:kAllLeagues];
  NSMutableArray *leagues = [NSMutableArray array];
  for (NSData *encodedLeague in encodedLeagues) {
      SBLeague *league = (SBLeague *)[NSKeyedUnarchiver unarchiveObjectWithData:encodedLeague];
      [leagues addObject:league];
  }

  _leagues = leagues;
  _favoriteTeams = @[];

  [self getFavoriteTeams:NO];
}

- (void)getFavoriteTeams:(BOOL)clearCache {
  if (!self.currentPfUser.objectId) {
    return;
  }

  PFQuery *query = [PFQuery queryWithClassName:@"TeamCount"];
  query.cachePolicy = kPFCachePolicyCacheThenNetwork;
  [query whereKey:@"user" equalTo:self.currentPfUser];
  [query orderByDescending:@"favoriteCount"];

  if (clearCache) {
    [query clearCachedResult];
  }

  [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
    _favoriteTeams = objects;
  }];
}

- (BOOL)teamLogos {
  return YES;
}

- (void)setAppOpens:(NSNumber *)appOpens {
  _appOpens = appOpens;
}

- (BOOL)askForAppReview {
  if (([self.appOpens intValue] > kAppOpensCountForNotification) && !self.alreadyAskedForReview) {
    return YES;
  }
  
  return NO;
}

- (void)rejectedAppReview {
  self.alreadyAskedForReview = YES;
  [self syncUserDefaults];
  
  [[Mixpanel sharedInstance] track:@"askedForReview" properties:@{@"succeeded": @"NO"}];
}

- (void)acceptedAppReview {
  self.alreadyAskedForReview = YES;
  [self syncUserDefaults];
  
  [[Mixpanel sharedInstance] track:@"askedForReview" properties:@{@"succeeded": @"YES"}];
}

- (NSArray *)enabledLeagues {
  NSMutableArray *enabledLeagues = [NSMutableArray array];

  for (SBLeague *league in self.leagues) {
    if ([league isEnabled]) {
      [enabledLeagues addObject:league];
    }
  }

  return enabledLeagues;
}

@end