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

@interface SBBoxscore : SBModel

@property (nonatomic, strong) NSArray *scoreSummary;
@property (nonatomic, strong) NSArray *scoreDetail;
@property (nonatomic, strong) SBRecap *recap;

@end