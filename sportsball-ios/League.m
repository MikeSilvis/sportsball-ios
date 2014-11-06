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
  nfl.name = @"nfl";

  League *nhl = [[League alloc] init];
  nhl.logo = @"nhl-logo";
  nhl.name = @"nhl";
  nhl.background = @"nhl-header-1";

  return @[
           nhl,
           nfl
           ];

}

-(NSString *)scoresUrl {
  return [NSString stringWithFormat:@"http://sportsball.herokuapp.com/api/scores/%@", self.name];
}

@end
