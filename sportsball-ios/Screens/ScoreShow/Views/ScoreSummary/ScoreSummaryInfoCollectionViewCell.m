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
  }

  UIFont *boldFont = [UIFont fontWithName:@"Avenir-Heavy" size:16];
  if (self.section == 0) {
    self.score.font = boldFont;
  }
  else {
    if (self.row == ([self scoreSummaryCount] -1)) {
      self.score.font = boldFont;
    }
  }
}

-(NSString *)summary {
  return self.game.boxscore.scoreSummary[self.section][self.row];
}

-(NSArray *)scoreSummary {
  return self.game.boxscore.scoreSummary;
}

-(NSUInteger)scoreSummaryCount {
  return [[self scoreSummary] count];
}

@end
