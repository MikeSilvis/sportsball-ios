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

static NSString *kLastOpenedLeague = @"lastOpenedLeague1";
static NSString *kLastOpenedScoreOrStandings = @"LastOpenedScoreOrStandings";
static NSString *kAllLeagues = @"allLeagues-1";

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

#pragma mark - Sync settings

- (void)syncUserDefaults {
  NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];

  [defaults setObject:self.lastOpenedLeagueIndex forKey:kLastOpenedLeague];
  [defaults setObject:self.lastOpenedScoreOrStandings forKey:kLastOpenedScoreOrStandings];

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

@end