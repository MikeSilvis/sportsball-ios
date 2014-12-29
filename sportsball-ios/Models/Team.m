//
//  Team.m
//  sportsball-ios
//
//  Created by Mike Silvis on 10/31/14.
//  Copyright (c) 2014 Mike Silvis. All rights reserved.
//

#import "Team.h"
#import "UIImage+Resize.h"

@implementation Team

-(id)initWithJson:(id)json {
  self = [super init];

  if (self) {
    self.name = json[@"name"];
    self.logoUrl = [NSURL URLWithString:json[@"logo"]];
    self.record = json[@"record"];
    self.dataName = json[@"data_name"];
  }

  return self;
}

-(NSString *)formattedRecord {
  return [NSString stringWithFormat:@"(%@)", self.record];
}

@end
