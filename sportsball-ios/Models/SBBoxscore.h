//
//  Boxscore.h
//  sportsball-ios
//
//  Created by Mike Silvis on 11/30/14.
//  Copyright (c) 2014 Mike Silvis. All rights reserved.
//

#import "SBModel.h"
#import "SBScoreDetail.h"
#import "SBRecap.h"
#import "SBGameInfo.h"
#import "SBGameStats.h"
#import "SBTeam.h"

@interface SBBoxscore : SBModel

@property (nonatomic, strong) NSArray *scoreSummary;
@property (nonatomic, strong) NSArray *scoreDetail;
@property (nonatomic, strong) SBRecap *recap;
@property (nonatomic, strong) SBGameInfo *gameInfo;
@property (nonatomic, strong) SBGameStats *gameStats;
@property (nonatomic, strong) SBTeam *awayTeam;
@property (nonatomic, strong) SBTeam *homeTeam;

@end