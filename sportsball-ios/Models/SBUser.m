//
//  User.m
//  sportsball-ios
//
//  Created by Mike Silvis on 11/23/14.
//  Copyright (c) 2014 Mike Silvis. All rights reserved.
//

#import "SBUser.h"
#import "UIImage+FontAwesome.h"
#import <Parse/Parse.h>

static NSString *kLastOpenedLeague = @"lastOpenedLeague1";
static NSString *kAllLeagues = @"allLeagues-1";
static NSString *kFavoriteTeams = @"favoriteTeams-1";

@interface SBUser ()

@property (nonatomic, strong) PFUser *currentPfUser;

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
    [self setUserDefaults];
    [PFUser enableAutomaticUser];
    [[PFUser currentUser] incrementKey:@"openCount"];
    self.currentPfUser = [PFUser currentUser];
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
  NSMutableDictionary *favoriteTeams = [NSMutableDictionary dictionaryWithDictionary:self.favoriteTeams];
  NSMutableDictionary *leagueFavoriteTeams = favoriteTeams[league] ? [NSMutableDictionary dictionaryWithDictionary:favoriteTeams[league]] : [NSMutableDictionary dictionary];

  for (SBTeam *team in @[homeTeam, awayTeam]) {
    NSNumber *teamFavoriteCount = (NSNumber *)leagueFavoriteTeams[team.dataName];
    if (teamFavoriteCount) {
      leagueFavoriteTeams[team.dataName] = @([teamFavoriteCount intValue] + 1);
    }
    else {
      leagueFavoriteTeams[team.dataName] = @1;
    }
  }

  favoriteTeams[league] = leagueFavoriteTeams;
  self.favoriteTeams = favoriteTeams;
  [self syncUserDefaults];

  // Save for parse
  [SBTeam incrementFavoriteTeam:homeTeam];
  [SBTeam incrementFavoriteTeam:awayTeam];
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

- (NSString *)networkConnectionErrorMessage:(NSError *)error {
  return @"No Network Connection";
}

- (UIImage *)networkConnectionErrorIcon {
  CGFloat iconSize = 15;
  FAKFontAwesome *carretIcon = [FAKFontAwesome warningIconWithSize:iconSize];

  return [UIImage imageWithFontAwesomeIcon:carretIcon andSize:iconSize andColor:@"#c4eefe"];
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

  [self.currentPfUser saveInBackground];
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