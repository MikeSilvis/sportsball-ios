//
//  Preview.m
//  sportsball-ios
//
//  Created by Mike Silvis on 1/8/15.
//  Copyright (c) 2015 Mike Silvis. All rights reserved.
//

#import "SBPreview.h"
#import "SBSchedule.h"
#import "Underscore.h"
#import "SBUser.h"

@implementation SBPreview

- (id)initWithJson:(id)json {
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
      SBSchedule *schedule = [[SBSchedule alloc] initWithJson:scheduleJson];
      [awayTeamSchedule addObject:schedule];
    }
    self.awayTeamSchedule = awayTeamSchedule;

    // Home Team Schedule
    NSMutableArray *homeTeamSchedule = [NSMutableArray array];
    for (id scheduleJson in json[@"home_team_schedule"][@"games"]) {
      SBSchedule *schedule = [[SBSchedule alloc] initWithJson:scheduleJson];
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

- (NSArray *)scheduleForTeam:(SBTeam *)team {
  NSArray *fullSchedule = team.isAway ? self.awayTeamSchedule : self.homeTeamSchedule;

  if (![[SBUser currentUser].lastOpenedLeague.isMonthlySchedule boolValue]) {
    return fullSchedule;
  }

  NSDateComponents *components = [[NSCalendar currentCalendar] components:NSCalendarUnitDay|NSCalendarUnitMonth|NSCalendarUnitYear
                                                               fromDate:[NSDate date]];
  NSUInteger currentMonth = [components month];

  return Underscore.array(fullSchedule).filter(^BOOL(SBSchedule *schedule) {
                              NSDateComponents *components = [[NSCalendar currentCalendar] components:NSCalendarUnitDay|NSCalendarUnitMonth|NSCalendarUnitYear
                                                                                             fromDate:schedule.date];
                              return [components month] == currentMonth;
                            }).unwrap;
}

@end