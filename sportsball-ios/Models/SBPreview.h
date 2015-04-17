//
//  Preview.h
//  sportsball-ios
//
//  Created by Mike Silvis on 1/8/15.
//  Copyright (c) 2015 Mike Silvis. All rights reserved.
//

#import "SBModel.h"
#import "SBTeam.h"
#import "SBLeague.h"
#import "SBGameInfo.h"

@interface SBPreview : SBModel

@property (nonatomic, strong) NSString *content;
@property (nonatomic, strong) NSString *headline;
@property (nonatomic, strong) NSURL *url;
@property (nonatomic, strong) NSDateFormatter *df;
@property (nonatomic, strong) SBGameInfo *gameInfo;

@property (nonatomic, strong) NSArray *homeTeamSchedule;
@property (nonatomic, strong) NSArray *awayTeamSchedule;
@property (nonatomic, strong) NSURL *photoURL;


- (NSArray *)scheduleForTeam:(SBTeam *)team;

@end
