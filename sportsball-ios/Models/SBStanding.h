//
//  SBStanding.h
//  sportsball-ios
//
//  Created by Mike Silvis on 3/17/15.
//  Copyright (c) 2015 Mike Silvis. All rights reserved.
//

#import "SBModel.h"

@interface SBStanding : SBModel

@property (nonatomic, strong) NSString *leagueName;
@property (nonatomic, strong) NSArray *headers;
@property (nonatomic, strong) NSDictionary *divisions;

@end
