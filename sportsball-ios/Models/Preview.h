//
//  Preview.h
//  sportsball-ios
//
//  Created by Mike Silvis on 1/8/15.
//  Copyright (c) 2015 Mike Silvis. All rights reserved.
//

#import "Champion.h"
#import "Team.h"

@interface Preview : Champion

@property (nonatomic, strong) NSString *content;
@property (nonatomic, strong) NSString *startTime;
@property (nonatomic, strong) NSString *location;
@property (nonatomic, strong) NSString *channel;

@end
