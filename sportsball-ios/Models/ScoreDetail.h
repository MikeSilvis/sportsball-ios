//
//  ScoreDetail.h
//  sportsball-ios
//
//  Created by Mike Silvis on 12/4/14.
//  Copyright (c) 2014 Mike Silvis. All rights reserved.
//

#import "Champion.h"

@interface ScoreDetail : Champion

@property (nonatomic, strong) NSString *headerInfo;
@property (nonatomic, strong) NSArray *contentInfo;
@property (nonatomic, strong) NSArray *headerRow;

@end
