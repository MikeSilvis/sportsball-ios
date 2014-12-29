//
//  League.h
//  sportsball-ios
//
//  Created by Mike Silvis on 11/6/14.
//  Copyright (c) 2014 Mike Silvis. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Champion.h"

@interface League : Champion

@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSURL *logo;
@property (nonatomic, strong) NSURL *header;
@property (nonatomic, strong) NSURL *blurredHeader;
@property (nonatomic, strong) NSArray *schedule;

+(void)getSupportedLeagues:(void (^) (NSArray *leagues))success
                   failure:(void (^) (NSError *error))failure;

- (void)allScoresForDate:(NSDate *)date
             parameters:(id)parameters
                success:(void (^) (NSArray *games))success
                failure:(void (^) (NSError *error))failure;

@end