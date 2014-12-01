//
//  Boxscore.m
//  sportsball-ios
//
//  Created by Mike Silvis on 11/30/14.
//  Copyright (c) 2014 Mike Silvis. All rights reserved.
//

#import "Boxscore.h"

@implementation Boxscore

-(id)initWithJson:(id)json {
  Boxscore *boxscore = [[Boxscore alloc] init];

  boxscore.scoreSummary = json[@"score_summary"];

  return boxscore;
}

@end
