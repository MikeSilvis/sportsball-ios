//
//  Preview.m
//  sportsball-ios
//
//  Created by Mike Silvis on 1/8/15.
//  Copyright (c) 2015 Mike Silvis. All rights reserved.
//

#import "Preview.h"
#import "Schedule.h"

@implementation Preview

-(id)initWithJson:(id)json {
  self = [super init];

  if (self) {
    self.headline   = json[@"headline"];
    self.content    = json[@"content"];
    self.startTime  = [NSDate dateWithTimeIntervalSince1970:[json[@"start_time"] doubleValue]];
    self.location   = json[@"location"];
    self.channel    = json[@"channel"];
    self.url        = [NSURL URLWithString:json[@"url"]];


    // Away Team Schedule
    NSMutableArray *awayTeamSchedule = [NSMutableArray array];
    for (id scheduleJson in json[@"away_team_schedule"][@"games"]) {
      Schedule *schedule = [[Schedule alloc] initWithJson:scheduleJson];
      [awayTeamSchedule addObject:schedule];
    }
    self.awayTeamSchedule = awayTeamSchedule;

    // Home Team Schedule
    NSMutableArray *homeTeamSchedule = [NSMutableArray array];
    for (id scheduleJson in json[@"home_team_schedule"][@"games"]) {
      Schedule *schedule = [[Schedule alloc] initWithJson:scheduleJson];
      [homeTeamSchedule addObject:schedule];
    }
    self.homeTeamSchedule = homeTeamSchedule;
  }

  return self;
}

- (NSDateFormatter *)df {
  if (!_df) {
    _df = [[NSDateFormatter alloc] init];
    [_df setDateFormat: @"h:mm a"];
    [_df setTimeZone:[NSTimeZone localTimeZone]];
  }

  return _df;
}

- (NSString *)localStartTime {
  return [self.df stringFromDate:self.startTime];
}

-(NSString *)locationWithSplit{
  if (!self.location) {
    return @"";
  }

  NSArray *locations = [self.location componentsSeparatedByString:@","];
  NSString *restOfWord = [[locations subarrayWithRange:NSMakeRange(1, 2)] componentsJoinedByString:@","];

  return [NSString stringWithFormat:@"%@\n%@", locations[0], restOfWord];
}

-(NSArray *)scheduleForTeam:(Team *)team {
  if (team.isAway) {
    return self.awayTeamSchedule;
  }
  else {
    return self.homeTeamSchedule;
  }
}

@end
