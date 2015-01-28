//
//  SBGameInfo.h
//  sportsball-ios
//
//  Created by Mike Silvis on 1/27/15.
//  Copyright (c) 2015 Mike Silvis. All rights reserved.
//

#import "SBModel.h"

@interface SBGameInfo : SBModel

@property (nonatomic, strong) NSDate *startTime;
@property (nonatomic, strong) NSString *location;
@property (nonatomic, strong) NSString *channel;
@property (nonatomic, strong) NSString *odds;

- (NSDictionary *)elements;

@end