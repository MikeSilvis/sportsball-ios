//
//  User.h
//  sportsball-ios
//
//  Created by Mike Silvis on 11/23/14.
//  Copyright (c) 2014 Mike Silvis. All rights reserved.
//

#import "Champion.h"
#import "Team.h"

@interface User : Champion

@property (nonatomic, copy) NSNumber *lastOpenedLeague;
@property (nonatomic, copy) NSArray *leagues;
@property (nonatomic, copy) NSDictionary *favoriteTeams;

+ (User *)currentUser;
- (void)appendFavoriteTeams:(Team *)team andTeam:(Team *)team2 andLeague:(NSString *)league;

@end