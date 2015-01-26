//
//  Schedule.h
//  sportsball-ios
//
//  Created by Mike Silvis on 1/13/15.
//  Copyright (c) 2015 Mike Silvis. All rights reserved.
//

#import "SportsBallModel.h"
#import "Team.h"

@interface Schedule : SportsBallModel

@property (nonatomic, strong) Team *opponent;
@property (nonatomic, strong) NSDate *date;
@property (nonatomic, strong) NSDate *startTime;
@property (nonatomic, strong) NSString *result;
@property BOOL isOver;
@property BOOL isWin;
@property BOOL isAway;

- (NSString *)localStartTime;

@end
