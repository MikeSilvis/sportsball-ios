//
//  ScoreDetail.m
//  sportsball-ios
//
//  Created by Mike Silvis on 12/4/14.
//  Copyright (c) 2014 Mike Silvis. All rights reserved.
//

#import "SBScoreDetail.h"

@implementation SBScoreDetail

- (id)initWithJson:(id)json {
  self = [super init];

  if (self) {
    if (json[@"header_info"] != [NSNull null]) {
      self.headerInfo = json[@"header_info"];
    }
    else {
      self.headerInfo = @"Penalty Summary";
    }

    if (json[@"content_info"] != [NSNull null]) {
      self.contentInfo = json[@"content_info"];
    }
    else {
      self.contentInfo = @[];
    }
  }

  return self;
}

@end
