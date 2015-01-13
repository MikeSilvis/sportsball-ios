//
//  Schedule.m
//  sportsball-ios
//
//  Created by Mike Silvis on 1/13/15.
//  Copyright (c) 2015 Mike Silvis. All rights reserved.
//

#import "Schedule.h"

@implementation Schedule

-(id)initWithJson:(id)json {
  self = [super init];

  if (self) {
    self.opponent = [[Team alloc] initWithJson:json[@"opponent"]];
    self.date = [self.dateFormatter dateFromString:json[@"date"]];
    self.result = json[@"result"];
  }

  return self;
}

@end