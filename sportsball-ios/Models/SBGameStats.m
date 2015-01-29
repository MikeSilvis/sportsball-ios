//
//  SBGameStats.m
//  sportsball-ios
//
//  Created by Mike Silvis on 1/28/15.
//  Copyright (c) 2015 Mike Silvis. All rights reserved.
//

#import "SBGameStats.h"

@implementation SBGameStats

- (id)initWithJson:(id)json {
  self = [super init];

  if (self) {
    self.headers       = json[@"header"];
    self.awayTeamStats = json[@"away_stats"];
    self.homeTeamStats = json[@"home_stats"];
  }

  return self;
}

@end
