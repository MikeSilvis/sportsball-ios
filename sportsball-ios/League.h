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

@property (nonatomic, retain) NSString *name;
@property (nonatomic, retain) NSString *logo;
@property (nonatomic, retain) NSString *background;
@property (nonatomic, retain) NSString *header;
@property (nonatomic, retain) UIImage *blurredHeader;


+(NSArray *)supportedLeagues;

-(void)allScoresForDate:(NSDate *)date
             parameters:(id)parameters
                success:(void (^) (NSArray *games))success
                failure:(void (^) (NSError *error))failure;

@end