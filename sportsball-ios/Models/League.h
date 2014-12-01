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
@property (nonatomic, strong) NSString *logo;
@property (nonatomic, strong) NSString *background;
@property (nonatomic, strong) NSString *header;
@property (nonatomic, strong) UIImage *blurredHeader;
@property (nonatomic, strong) NSString *datePickerType;
@property (nonatomic, assign) NSInteger numberOfWeeks;

+ (NSArray *)supportedLeagues;
- (NSArray *)datesForPicker:(NSDate *)date;

- (void)allScoresForDate:(NSDate *)date
             parameters:(id)parameters
                success:(void (^) (NSArray *games))success
                failure:(void (^) (NSError *error))failure;

@end