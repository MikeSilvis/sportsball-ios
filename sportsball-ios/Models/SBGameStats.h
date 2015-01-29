//
//  SBGameStats.h
//  sportsball-ios
//
//  Created by Mike Silvis on 1/28/15.
//  Copyright (c) 2015 Mike Silvis. All rights reserved.
//

#import "SBModel.h"

@interface SBGameStats : SBModel

@property (nonatomic, strong) NSArray *headers;
@property (nonatomic, strong) NSArray *awayTeamStats;
@property (nonatomic, strong) NSArray *homeTeamStats;

@end
