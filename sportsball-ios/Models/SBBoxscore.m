//
//  Boxscore.m
//  sportsball-ios
//
//  Created by Mike Silvis on 11/30/14.
//  Copyright (c) 2014 Mike Silvis. All rights reserved.
//

#import "SBBoxscore.h"

@interface SBBoxscore ()

@property (nonatomic, strong) NSDateFormatter *localStartTimeDfWithDate;

@end

@implementation SBBoxscore

- (id)initWithJson:(id)json {
  self = [super init];

  if (self) {
    self.scoreSummary = json[@"score_summary"];
    self.startTime    = [NSDate dateWithTimeIntervalSince1970:[json[@"start_time"] doubleValue]];
    self.location     = json[@"location"];
    self.channel      = json[@"channel"];

    NSMutableArray *scoreDetails = [NSMutableArray array];
    for (id scoreDetail in json[@"score_detail"]) {
      SBScoreDetail *detail = [[SBScoreDetail alloc] initWithJson:scoreDetail];
      [scoreDetails addObject:detail];
    }

    self.scoreDetail = scoreDetails;
    self.recap = [[SBRecap alloc] initWithJson:json[@"recap"]];
  }

  return self;
}

- (NSString *)localStartTimeWithDate {
  return [self.localStartTimeDfWithDate stringFromDate:self.startTime];
}

- (NSDateFormatter *)localStartTimeDfWithDate {
  if (!_localStartTimeDfWithDate) {
    _localStartTimeDfWithDate = [[NSDateFormatter alloc] init];
    _localStartTimeDfWithDate.dateStyle = NSDateFormatterMediumStyle;
    _localStartTimeDfWithDate.timeStyle = NSDateFormatterShortStyle;
    [_localStartTimeDfWithDate setTimeZone:[NSTimeZone localTimeZone]];
  }

  return _localStartTimeDfWithDate;
}

@end
