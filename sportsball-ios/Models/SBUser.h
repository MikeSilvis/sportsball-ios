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
#import <Parse/Parse.h>

@interface SBUser : SBModel

@property (nonatomic, strong) SBLeague *lastOpenedLeague;
@property (nonatomic, copy) NSNumber *lastOpenedLeagueIndex;
@property (nonatomic, copy) NSNumber *lastOpenedScoreOrStandings;
@property (nonatomic, copy) NSArray *leagues;
@property (nonatomic, copy) NSArray *favoriteTeams;
@property (atomic, strong) PFUser *currentPfUser;

+ (SBUser *)currentUser;
- (void)appendFavoriteTeams:(SBTeam *)team andTeam:(SBTeam *)team2 andLeague:(NSString *)league;
- (NSString *)favoriteTeam:(SBLeague *)league;
- (NSString *)networkConnectionErrorMessage:(NSError *)error;
- (UIImage *)networkConnectionErrorIcon;
- (BOOL)teamLogos;

@end