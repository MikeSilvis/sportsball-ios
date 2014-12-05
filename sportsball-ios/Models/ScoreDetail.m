//
//  ScoreDetail.m
//  sportsball-ios
//
//  Created by Mike Silvis on 12/4/14.
//  Copyright (c) 2014 Mike Silvis. All rights reserved.
//

#import "ScoreDetail.h"

@implementation ScoreDetail

-(id)initWithJson:(id)json {
  self = [super init];

  if (self) {
    self.headerInfo = json[@"header_info"];
    self.contentInfo = json[@"content_info"];
    self.headerRow = json[@"header_row"];
  }

  return self;
}

@end
