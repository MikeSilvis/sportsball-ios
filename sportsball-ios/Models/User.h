//
//  User.h
//  sportsball-ios
//
//  Created by Mike Silvis on 11/23/14.
//  Copyright (c) 2014 Mike Silvis. All rights reserved.
//

#import "Champion.h"

@interface User : Champion

+ (User *)currentUser;

@property (nonatomic, copy) NSNumber *lastOpenedLeague;
@property (nonatomic, copy) NSArray *leagues;

@end