//
//  Team.m
//  sportsball-ios
//
//  Created by Mike Silvis on 10/31/14.
//  Copyright (c) 2014 Mike Silvis. All rights reserved.
//

#import "Team.h"

@implementation Team

-(id)initWithJson:(id)json {
  self = [super init];

  if (self) {
    self.name = json[@"name"];
    self.logoUrl = json[@"logo"];
    self.wins = json[@"wins"];
    self.loses = json[@"loses"];
  }

  return self;
}

-(NSString *)formattedRecord {
  return [NSString stringWithFormat:@"(%@-%@)", self.wins, self.loses];
}
@end
