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
    self.startTime  = json[@"start_time"];
    self.location   = json[@"location"];
    self.channel    = json[@"channel"];
    self.url        = [NSURL URLWithString:json[@"url"]];
  }

  return self;
}

@end
