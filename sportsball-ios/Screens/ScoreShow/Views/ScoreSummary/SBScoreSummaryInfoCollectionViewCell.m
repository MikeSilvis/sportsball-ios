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

  UIFont *regularFont = [UIFont fontWithName:@"Avenir-Roman" size:12];

  NSString *summary = self.game.boxscore.scoreSummary[self.indexPath.section][self.indexPath.row];

  SBTeam *team = [self.game teamFromDataName:summary];

  if (team) {
    self.textLabel.text = team.name;
    self.textLabel.textAlignment = NSTextAlignmentLeft;
    self.textLabel.font = [self boldFont];
  }
  else {
    self.textLabel.text = summary;
    self.textLabel.textAlignment = NSTextAlignmentCenter;
    self.textLabel.font = regularFont;
  }

  if (self.indexPath.section == 0 && self.indexPath.row == 0 ) {
    self.textLabel.textAlignment = NSTextAlignmentLeft;
  }
  if (self.indexPath.row == 0) {
    self.textLabel.font = [self boldFont];
  }

  if (self.indexPath.section == ([self.game.boxscore.scoreSummary count] - 1)) {
    self.textLabel.font = [self boldFont];
  }
}

- (void)setStanding:(SBStanding *)standing {
  _standing = standing;

  self.textLabel.font = [self boldFont];

  if (self.indexPath.row == 0) {
    self.textLabel.text = [self.standing.divisions allKeys][self.outerIndexPath.section];
    self.textLabel.textAlignment = NSTextAlignmentLeft;
  }
  else {
    self.textLabel.text = self.standing.headers[self.indexPath.row - 1];
    self.textLabel.textAlignment = NSTextAlignmentCenter;
  }
}

- (UIFont *)boldFont {
  return [UIFont fontWithName:@"Avenir-Heavy" size:14];
}

@end
