//
//  Team.h
//  sportsball-ios
//
//  Created by Mike Silvis on 10/31/14.
//  Copyright (c) 2014 Mike Silvis. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Champion.h"

@interface Team : Champion

@property (nonatomic, strong) NSURL *logoUrl;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSNumber *wins;
@property (nonatomic, strong) NSNumber *loses;
@property (nonatomic, strong) NSString *record;

-(NSString *)formattedRecord;
@end
