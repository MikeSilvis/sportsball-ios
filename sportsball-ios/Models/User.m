//
//  User.m
//  sportsball-ios
//
//  Created by Mike Silvis on 11/23/14.
//  Copyright (c) 2014 Mike Silvis. All rights reserved.
//

#import "User.h"
#import "League.h"

static NSString *lastOpenedLeagueKey = @"lastOpenedLeague";
static NSString *allLeagues = @"allLeagues";
static NSString *favoriteTeamsKey = @"favoriteTeams";

@implementation User

+ (User *)currentUser {
  static User *currentUser = nil;

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

- (void)setLastOpenedLeagueIindex:(NSNumber *)lastOpenedLeague {
  _lastOpenedLeagueIindex = lastOpenedLeague;

  [self syncUserDefaults];
}

- (void)setLeagues:(NSArray *)leagues {
  _leagues = leagues;

  [self syncUserDefaults];
}

- (void)appendFavoriteTeams:(Team *)homeTeam andTeam:(Team *)awayTeam andLeague:(NSString *)league {
  NSMutableDictionary *favoriteTeams = [NSMutableDictionary dictionaryWithDictionary:self.favoriteTeams];
  NSMutableDictionary *leagueFavoriteTeams = favoriteTeams[league] ? [NSMutableDictionary dictionaryWithDictionary:favoriteTeams[league]] : [NSMutableDictionary dictionary];

  for (Team *team in @[homeTeam, awayTeam]) {
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

#pragma mark - Sync settings

- (void)syncUserDefaults {
  NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];

  [defaults setObject:self.lastOpenedLeagueIindex forKey:lastOpenedLeagueKey];

  if (self.favoriteTeams.count > 0) {
    [defaults setObject:self.favoriteTeams forKey:favoriteTeamsKey];
  }

  // Set Leagues
  NSMutableArray *encodedLeagues = [NSMutableArray array];
  for (League *league in self.leagues) {
    NSData *encodedNewLeague = [NSKeyedArchiver archivedDataWithRootObject:league];
    [encodedLeagues addObject:encodedNewLeague];
  }

  if (encodedLeagues.count > 0) {
    [defaults setObject:encodedLeagues forKey:allLeagues];
  }

  [defaults synchronize];
}

- (void)setUserDefaults {
  NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];

  _lastOpenedLeagueIindex = [defaults objectForKey:lastOpenedLeagueKey];
  _favoriteTeams = [defaults objectForKey:favoriteTeamsKey] ? [defaults objectForKey:favoriteTeamsKey] : @{};

  // Retrieve leagues
  NSArray *encodedLeagues = [defaults objectForKey:allLeagues];
  NSMutableArray *leagues = [NSMutableArray array];
  for (NSData *encodedLeague in encodedLeagues) {
      League *league = (League *)[NSKeyedUnarchiver unarchiveObjectWithData:encodedLeague];
      [leagues addObject:league];
  }

  _leagues = leagues;
}

@end