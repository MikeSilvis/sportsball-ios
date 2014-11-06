//
//  League.m
//  sportsball-ios
//
//  Created by Mike Silvis on 11/6/14.
//  Copyright (c) 2014 Mike Silvis. All rights reserved.
//

#import "League.h"

@implementation League

+(NSArray *)supportedLeagues {
  League *nfl = [[League alloc] init];
  nfl.logo = @"nfl-logo";
  nfl.background = @"nfl-header-1";

  League *nhl = [[League alloc] init];
  nhl.logo = @"nhl-logo";
  nhl.background = @"nhl-header-1";

  return @[
           nhl,
           nfl
           ];

}

@end
