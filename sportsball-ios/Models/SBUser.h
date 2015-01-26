//
//  User.h
//  sportsball-ios
//
//  Created by Mike Silvis on 11/23/14.
//  Copyright (c) 2014 Mike Silvis. All rights reserved.
//

#import "SBModel.h"
#import "SBTeam.h"
#import "SBLeague.h"

@interface SBUser : SBModel

@property (nonatomic, strong) SBLeague *lastOpenedLeague;
@property (nonatomic, copy) NSNumber *lastOpenedLeagueIndex;
@property (nonatomic, copy) NSArray *leagues;
@property (nonatomic, copy) NSDictionary *favoriteTeams;

+ (SBUser *)currentUser;
- (void)appendFavoriteTeams:(SBTeam *)team andTeam:(SBTeam *)team2 andLeague:(NSString *)league;
- (NSString *)favoriteTeam:(SBLeague *)league;

@end