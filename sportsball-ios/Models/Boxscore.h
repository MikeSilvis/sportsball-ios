//
//  Boxscore.h
//  sportsball-ios
//
//  Created by Mike Silvis on 11/30/14.
//  Copyright (c) 2014 Mike Silvis. All rights reserved.
//

#import "Champion.h"
#import "ScoreDetail.h"

@interface Boxscore : Champion

@property (nonatomic, strong) NSArray *scoreSummary;
@property (nonatomic, strong) NSArray *scoreDetail;

@end