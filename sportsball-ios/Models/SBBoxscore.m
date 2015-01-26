//
//  Boxscore.m
//  sportsball-ios
//
//  Created by Mike Silvis on 11/30/14.
//  Copyright (c) 2014 Mike Silvis. All rights reserved.
//

#import "SBBoxscore.h"

@implementation SBBoxscore

- (id)initWithJson:(id)json {
  SBBoxscore *boxscore = [[SBBoxscore alloc] init];

  boxscore.scoreSummary = json[@"score_summary"];

  NSMutableArray *scoreDetails = [NSMutableArray array];
  for (id scoreDetail in json[@"score_detail"]) {
    SBScoreDetail *detail = [[SBScoreDetail alloc] initWithJson:scoreDetail];
    [scoreDetails addObject:detail];
  }

  boxscore.scoreDetail = scoreDetails;
  boxscore.recap = [[SBRecap alloc] initWithJson:json[@"recap"]];

  return boxscore;
}

@end
