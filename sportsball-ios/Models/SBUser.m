//
//  User.m
//  sportsball-ios
//
//  Created by Mike Silvis on 11/23/14.
//  Copyright (c) 2014 Mike Silvis. All rights reserved.
//

#import "SBUser.h"
#import "SBLeague.h"

static NSString *kLastOpenedLeague = @"lastOpenedLeague1";
static NSString *kAllLeagues = @"allLeagues-1";
static NSString *kFavoriteTeams = @"favoriteTeams-1";

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
    [self setUserDefaults];
  }

  return self;
}

- (void)setLastOpenedLeagueIndex:(NSNumber *)lastOpenedLeague {
  _lastOpenedLeagueIndex = lastOpenedLeague;

  [self syncUserDefaults];
}

- (void)setLeagues:(NSArray *)leagues {
  _leagues = leagues;

  [self syncUserDefaults];
}

- (void)appendFavoriteTeams:(SBTeam *)homeTeam andTeam:(SBTeam *)awayTeam andLeague:(NSString *)league {
  NSMutableDictionary *favoriteTeams = [NSMutableDictionary dictionaryWithDictionary:self.favoriteTeams];
  NSMutableDictionary *leagueFavoriteTeams = favoriteTeams[league] ? [NSMutableDictionary dictionaryWithDictionary:favoriteTeams[league]] : [NSMutableDictionary dictionary];

  for (SBTeam *team in @[homeTeam, awayTeam]) {
    NSNumber *teamFavoriteCount = (NSNumber *)leagueFavoriteTeams[team.dataName];
    if (teamFavoriteCount) {
      leagueFavoriteTeams[team.dataName] = [NSNumber numberWithInt:([teamFavoriteCount intValue] + 1)];
    }
    else {
      leagueFavoriteTeams[team.dataName] = @1;
    }
  }

  favoriteTeams[league] = leagueFavoriteTeams;
  self.favoriteTeams = favoriteTeams;
  [self syncUserDefaults];
}

- (NSString *)favoriteTeam:(SBLeague *)league {
  NSDictionary *teams = self.favoriteTeams[league.name];

  if (self.favoriteTeams && teams) {
    NSString *largestTeamName;

    for (NSString *teamName in [teams allKeys]) {
      // If there is no largest team name yet
      if (!largestTeamName) {
        largestTeamName = teamName;
      }
      else if (teams[largestTeamName] < teams[teamName]) {
        largestTeamName = teamName;
      }

    }

    return largestTeamName;
  }

  return nil;
}

#pragma mark - Sync settings

- (void)syncUserDefaults {
  NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];

  [defaults setObject:self.lastOpenedLeagueIndex forKey:kLastOpenedLeague];

  if (self.favoriteTeams.count > 0) {
    [defaults setObject:self.favoriteTeams forKey:kFavoriteTeams];
  }

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
}

- (void)setUserDefaults {
  NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];

  _lastOpenedLeagueIndex = [defaults objectForKey:kLastOpenedLeague];
  _favoriteTeams = [defaults objectForKey:kFavoriteTeams] ? [defaults objectForKey:kFavoriteTeams] : @{};

  // Retrieve leagues
  NSArray *encodedLeagues = [defaults objectForKey:kAllLeagues];
  NSMutableArray *leagues = [NSMutableArray array];
  for (NSData *encodedLeague in encodedLeagues) {
      SBLeague *league = (SBLeague *)[NSKeyedUnarchiver unarchiveObjectWithData:encodedLeague];
      [leagues addObject:league];
  }

  _leagues = leagues;
}

@end