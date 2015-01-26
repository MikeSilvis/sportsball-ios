//
//  Recap.m
//  sportsball-ios
//
//  Created by Mike Silvis on 12/24/14.
//  Copyright (c) 2014 Mike Silvis. All rights reserved.
//

#import "Recap.h"

@implementation Recap

- (id)initWithJson:(id)json {
  self = [super init];

  if (self) {
    self.headline = json[@"headline"];
    self.content = json[@"content"];
    self.url = [NSURL URLWithString:json[@"url"]];
    self.photoURL = [NSURL URLWithString:json[@"photo"]];
  }

  return self;
}
@end
