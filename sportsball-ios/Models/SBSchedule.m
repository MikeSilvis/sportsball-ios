//
//  Schedule.m
//  sportsball-ios
//
//  Created by Mike Silvis on 1/13/15.
//  Copyright (c) 2015 Mike Silvis. All rights reserved.
//

#import "SBSchedule.h"

@implementation SBSchedule

- (id)initWithJson:(id)json {
  self = [super init];

  if (self) {
    self.opponent   = [[SBTeam alloc] initWithJson:json[@"opponent"]];
    self.date       = [self.dateFormatter dateFromString:json[@"date"]];
    self.startTime  = [NSDate dateWithTimeIntervalSince1970:[json[@"start_time"] doubleValue]];
    self.result     = json[@"result"];
    self.isWin      = [json[@"win"] boolValue];
    self.isOver     = [json[@"over"] boolValue];
    self.isAway     = [json[@"is_away"] boolValue];
  }

  return self;
}

- (NSString *)localStartTime {
  return [self.localStartTimeDf stringFromDate:self.startTime];
}

@end