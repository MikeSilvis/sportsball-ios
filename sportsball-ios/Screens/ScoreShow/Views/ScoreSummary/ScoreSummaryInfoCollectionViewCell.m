//
//  ScoreSummaryInfoCollectionViewCell.m
//  sportsball-ios
//
//  Created by Mike Silvis on 12/4/14.
//  Copyright (c) 2014 Mike Silvis. All rights reserved.
//

#import "ScoreSummaryInfoCollectionViewCell.h"
#import "Team.h"

@implementation ScoreSummaryInfoCollectionViewCell

-(void)awakeFromNib {
  [super awakeFromNib];

  self.backgroundColor = [UIColor clearColor];
}

-(void)setGame:(Game *)game {
  _game = game;

  Team *team = [self.game teamFromDataName:[self summary]];
  if (team) {
    self.score.text = team.name;
    self.score.textAlignment = NSTextAlignmentLeft;
  }
  else {
    self.score.text = [self summary];
    self.score.textAlignment = NSTextAlignmentRight;
  }

  if (self.section == 0 && self.row == 0 ) {
    self.score.textAlignment = NSTextAlignmentLeft;
  }

  UIFont *boldFont = [UIFont fontWithName:@"Avenir-Heavy" size:14];
  UIFont *regularFont = [UIFont fontWithName:@"Avenir-Roman" size:12];
  self.score.font = regularFont;

  if (self.section == 0) {
    self.score.font = boldFont;
  }

  NSArray *rowCount = self.game.boxscore.scoreSummary[self.section];
  if (self.row == [rowCount count]) {
    self.score.font = boldFont;
  }
}

-(NSString *)summary {
  return self.game.boxscore.scoreSummary[self.section][self.row];
}

@end
