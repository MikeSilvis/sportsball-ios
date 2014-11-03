//
//  Game.m
//  sportsball-ios
//
//  Created by Mike Silvis on 10/31/14.
//  Copyright (c) 2014 Mike Silvis. All rights reserved.
//

#import "Game.h"

@implementation Game

-(Team *)winningTeam {
  if ([self.awayScore doubleValue] > [self.homeScore doubleValue]) {
    return self.awayTeam;
  } else {
    return self.homeTeam;
  }
}

-(id)initWithJson:(id)json {
  self = [super init];

  if (self) {
    self.homeTeam = [[Team alloc] initWithJson:json[@"home_team"]];
    self.homeScore = json[@"home_score"];

    self.awayTeam = [[Team alloc] initWithJson:json[@"away_team"]];
    self.awayScore = json[@"away_score"];
    self.league = json[@"league"];

    self.timeRemaining = json[@"time_remaining"];
    self.currentPeriod = json[@"progress"];
    self.endedIn = json[@"ended_in"];

    self.startTime = [NSDate dateWithTimeIntervalSince1970:[json[@"start_time"] doubleValue]];

    self.state = json[@"state"];
  }

  return self;
}

- (BOOL)isOver {
  return [self.state isEqualToString:@"final"];
}

-(BOOL)isInProgress {
  return [self.state isEqualToString:@"in-progress"];
}

-(BOOL)isPregame {
  return [self.state isEqualToString:@"pregame"];
}

-(NSString *)localStartTime {
  NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
  [formatter setDateFormat: @"h:mm a"];

  [formatter setTimeZone:[NSTimeZone localTimeZone]];

  return [formatter stringFromDate:self.startTime];
}

@end
