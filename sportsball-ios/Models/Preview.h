//
//  Preview.h
//  sportsball-ios
//
//  Created by Mike Silvis on 1/8/15.
//  Copyright (c) 2015 Mike Silvis. All rights reserved.
//

#import "SportsBallModel.h"
#import "Team.h"
#import "League.h"

@interface Preview : SportsBallModel

@property (nonatomic, strong) NSString *content;
@property (nonatomic, strong) NSString *headline;
@property (nonatomic, strong) NSDate *startTime;
@property (nonatomic, strong) NSString *location;
@property (nonatomic, strong) NSString *channel;
@property (nonatomic, strong) NSURL *url;
@property (nonatomic, strong) NSDateFormatter *df;

@property (nonatomic, strong) NSArray *homeTeamSchedule;
@property (nonatomic, strong) NSArray *awayTeamSchedule;

-(NSArray *)scheduleForTeam:(Team *)team;

@end
