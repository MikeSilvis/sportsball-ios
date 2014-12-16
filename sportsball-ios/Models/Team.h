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
@property (nonatomic, strong) NSString *record;
@property (nonatomic, strong) NSString *dataName;


-(NSString *)formattedRecord;
@end
