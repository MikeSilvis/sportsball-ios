//
//  ScoreDetailInfoCollectionViewCell.m
//  sportsball-ios
//
//  Created by Mike Silvis on 12/4/14.
//  Copyright (c) 2014 Mike Silvis. All rights reserved.
//

#import "ScoreDetailInfoCollectionViewCell.h"
#import <UIImageView+AFNetworking.h>

@implementation ScoreDetailInfoCollectionViewCell

-(void)awakeFromNib {
  [super awakeFromNib];
  self.backgroundColor = [UIColor clearColor];
}

-(void)setContentInfo:(NSArray *)contentInfo {
  _contentInfo = contentInfo;

  if ([self nothingHappend]) {
    self.time.text = @"";
    self.summary.text = @"";
    self.teamLogo.hidden = YES;
    self.noScores.text = self.contentInfo[0];
    return;
  }

  self.teamLogo.hidden = NO;

  int dataNameLocation;
  int summaryLocation;

  if ([self.game.league isEqualToString:@"nhl"]) {
    dataNameLocation = 1;
    summaryLocation = 2;

    self.time.text = self.contentInfo[0];
  }
  else {
    dataNameLocation = 0;
    summaryLocation = 2;

    self.time.text = self.contentInfo[1];
  }

  NSString *teamDataName = self.contentInfo[dataNameLocation];
  if ([self.game.awayTeam.dataName isEqualToString:teamDataName]) {
    [self.teamLogo setImageWithURL:[self.game.awayTeam logoURLWithSize:@"42x42"]];
  }
  else if ([self.game.homeTeam.dataName isEqualToString:teamDataName]) {
    [self.teamLogo setImageWithURL:[self.game.homeTeam logoURLWithSize:@"42x42"]];
  }

  self.summary.text = self.contentInfo[summaryLocation];
}

-(bool)nothingHappend {
  if ([self.contentInfo count] > 0) {
    return ([self.contentInfo[0] isEqualToString:@"No penalties this period"] || [self.contentInfo[0] isEqualToString:@"No scoring this period"]);
  }
  else {
    return false;
  }
}

@end
