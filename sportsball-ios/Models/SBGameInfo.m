//
//  SBGameInfo.m
//  sportsball-ios
//
//  Created by Mike Silvis on 1/27/15.
//  Copyright (c) 2015 Mike Silvis. All rights reserved.
//

#import "SBGameInfo.h"

@interface SBGameInfo ()

@property (nonatomic, strong) NSDateFormatter *localStartTimeDfWithDate;

@end

@implementation SBGameInfo

- (id)initWithJson:(id)json {
  self = [super init];

  if (self) {
    self.startTime    = [NSDate dateWithTimeIntervalSince1970:[json[@"start_time"] doubleValue]];
    self.location     = json[@"location"];
    self.channel      = json[@"channel"];
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

- (NSDictionary *)elements {
  NSMutableDictionary *mutableElements = [NSMutableDictionary dictionary];

  if (self.startTime) {
    mutableElements[@"Start Time"] = [self localStartTimeWithDate];
  }

  if (self.location) {
    mutableElements[@"Location"] = self.location;
  }

  if (self.channel) {
    mutableElements[@"Channel"] = self.channel;
  }
  
  return mutableElements;
}

@end
