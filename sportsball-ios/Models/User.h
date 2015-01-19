//
//  User.h
//  sportsball-ios
//
//  Created by Mike Silvis on 11/23/14.
//  Copyright (c) 2014 Mike Silvis. All rights reserved.
//

#import "SportsBallModel.h"
#import "Team.h"
#import "League.h"

@interface User : SportsBallModel

@property (nonatomic, strong) League *lastOpenedLeague;
@property (nonatomic, copy) NSNumber *lastOpenedLeagueIindex;
@property (nonatomic, copy) NSArray *leagues;
@property (nonatomic, copy) NSDictionary *favoriteTeams;

+ (User *)currentUser;
- (void)appendFavoriteTeams:(Team *)team andTeam:(Team *)team2 andLeague:(NSString *)league;
- (NSString *)favoriteTeam:(League *)league;

@end