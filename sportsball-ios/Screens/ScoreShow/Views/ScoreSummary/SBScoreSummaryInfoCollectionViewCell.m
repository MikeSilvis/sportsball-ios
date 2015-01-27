//
//  ScoreSummaryInfoCollectionViewCell.m
//  sportsball-ios
//
//  Created by Mike Silvis on 12/4/14.
//  Copyright (c) 2014 Mike Silvis. All rights reserved.
//

#import "SBScoreSummaryInfoCollectionViewCell.h"

@implementation SBScoreSummaryInfoCollectionViewCell

- (void)awakeFromNib {
  [super awakeFromNib];

  self.backgroundColor = [UIColor clearColor];
}

- (void)setGame:(SBGame *)game {
  _game = game;

  UIFont *boldFont = [UIFont fontWithName:@"Avenir-Heavy" size:14];
  UIFont *regularFont = [UIFont fontWithName:@"Avenir-Roman" size:12];

  SBTeam *team = [self.game teamFromDataName:[self summary]];

  if (team) {
    self.score.text = team.name;
    self.score.textAlignment = NSTextAlignmentLeft;
    self.score.font = boldFont;
  }
  else {
    self.score.text = [self summary];
    self.score.textAlignment = NSTextAlignmentCenter;
    self.score.font = regularFont;
  }

  if (self.section == 0 && self.row == 0 ) {
    self.score.textAlignment = NSTextAlignmentLeft;
  }

  if (self.section == 0) {
    self.score.font = boldFont;
  }

  NSArray *rowCount = self.game.boxscore.scoreSummary[self.section];
  if (self.row == ([rowCount count] -1)) {
    self.score.font = boldFont;
  }
}

- (NSString *)summary {
  return self.game.boxscore.scoreSummary[self.section][self.row];
}

@end
