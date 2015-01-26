//
//  Recap.h
//  sportsball-ios
//
//  Created by Mike Silvis on 12/24/14.
//  Copyright (c) 2014 Mike Silvis. All rights reserved.
//

#import "SBModel.h"

@interface SBRecap : SBModel

@property (nonatomic, strong) NSString *headline;
@property (nonatomic, strong) NSString *content;
@property (nonatomic, strong) NSURL *photoURL;
@property (nonatomic, strong) NSURL *url;

@end
