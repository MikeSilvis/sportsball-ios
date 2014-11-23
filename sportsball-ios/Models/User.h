//
//  User.h
//  sportsball-ios
//
//  Created by Mike Silvis on 11/23/14.
//  Copyright (c) 2014 Mike Silvis. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface User : NSObject

+ (User *)currentUser;

@property (nonatomic, copy) NSNumber *lastOpenedLeague;

@end