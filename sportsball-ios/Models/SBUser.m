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

static NSString *kLastOpenedLeague = @"lastOpenedLeague1";
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
    [self.currentPfUser incrementKey:@"openCount"];

    if (!self.currentPfUser[@"timeZone"]) {
      self.currentPfUser[@"timeZone"] = [[NSTimeZone localTimeZone] name];
      [self.currentPfUser saveEventually];
    }

    [self setUserDefaults];
  }

  return self;
}

- (void)setLastOpenedLeagueIndex:(NSNumber *)lastOpenedLeagueIndex {
  _lastOpenedLeagueIndex = lastOpenedLeagueIndex;

  self.currentPfUser[@"lastOpenedLeague"] = self.lastOpenedLeagueIndex;

  [self syncUserDefaults];
}

- (void)setLeagues:(NSArray *)leagues {
  _leagues = leagues;

  [self syncUserDefaults];
}

- (void)appendFavoriteTeams:(SBTeam *)homeTeam andTeam:(SBTeam *)awayTeam andLeague:(NSString *)league {
  [SBTeam incrementFavoriteTeam:homeTeam withSuccess:^(PFObject *object) {
    [self getFavoriteTeams:YES];
  }];

  [SBTeam incrementFavoriteTeam:awayTeam withSuccess:^(PFObject *object) {
    [self getFavoriteTeams:YES];
  }];

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

- (BOOL)secondaryLogos {
  return (self.currentPfUser[@"secondaryLogo"] == nil) || (self.currentPfUser[@"secondaryLogo"] == NO);
}

- (BOOL)teamLogos {
  return [self.currentPfUser[@"teamLogos"] boolValue];
}

@end