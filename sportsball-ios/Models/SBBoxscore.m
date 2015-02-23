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
  self = [super init];

  if (self) {
    self.scoreSummary = json[@"score_summary"];

    NSMutableArray *scoreDetails = [NSMutableArray array];
    for (id scoreDetail in json[@"score_detail"]) {
      SBScoreDetail *detail = [[SBScoreDetail alloc] initWithJson:scoreDetail];
      [scoreDetails addObject:detail];
    }

    self.scoreDetail = scoreDetails;
    self.recap = [[SBRecap alloc] initWithJson:json[@"recap"]];
    self.gameInfo = [[SBGameInfo alloc] initWithJson:json[@"game_info"]];
    self.gameStats = [[SBGameStats alloc] initWithJson:json[@"game_stats"]];

    self.awayTeam = [[SBTeam alloc] initWithJson:json[@"away_team"]];
    self.awayTeam.isAway = YES;

    self.homeTeam = [[SBTeam alloc] initWithJson:json[@"home_team"]];
    self.homeTeam.isAway = NO;
  }

  return self;
}

@end
