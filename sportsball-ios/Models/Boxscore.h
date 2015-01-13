//
//  Boxscore.h
//  sportsball-ios
//
//  Created by Mike Silvis on 11/30/14.
//  Copyright (c) 2014 Mike Silvis. All rights reserved.
//

#import "SportsBallModel.h"
#import "ScoreDetail.h"
#import "Recap.h"

@interface Boxscore : SportsBallModel

@property (nonatomic, strong) NSArray *scoreSummary;
@property (nonatomic, strong) NSArray *scoreDetail;
@property (nonatomic, strong) Recap *recap;

@end