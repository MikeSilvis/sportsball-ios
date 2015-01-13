//
//  Preview.m
//  sportsball-ios
//
//  Created by Mike Silvis on 1/8/15.
//  Copyright (c) 2015 Mike Silvis. All rights reserved.
//

#import "Preview.h"

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

@end
