//
//  SBStanding.m
//  sportsball-ios
//
//  Created by Mike Silvis on 3/17/15.
//  Copyright (c) 2015 Mike Silvis. All rights reserved.
//

#import "SBStanding.h"
#import "SBTeam.h"

@implementation SBStanding

- (id)initWithJson:(id)json {
  self = [super init];

  if (self) {
    self.leagueName = json[@"standings"][@"league"];
    self.headers    = json[@"standings"][@"headers"];

    NSMutableDictionary *divisions = [NSMutableDictionary dictionary];

    for (id division in json[@"standings"][@"divisions"]) {
      NSMutableArray *teams = [NSMutableArray array];

      for (id team in json[@"standings"][@"divisions"][division]) {
        SBTeam *newTeam = [[SBTeam alloc] initWithJson:team];
        [teams addObject:newTeam];
      }
      divisions[division] = [NSArray arrayWithArray:teams];
    }

    self.divisions = [NSDictionary dictionaryWithDictionary:divisions];
  }


  return self;
}

@end
