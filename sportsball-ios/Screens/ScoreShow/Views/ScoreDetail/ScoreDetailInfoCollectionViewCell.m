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
    [self.teamLogo setImageWithURL:[self.game.awayTeam imageURLWithSize:self.game.awayTeam.logoUrl andSize:@"42x42"]];
  }
  else if ([self.game.homeTeam.dataName isEqualToString:teamDataName]) {
    [self.teamLogo setImageWithURL:[self.game.homeTeam imageURLWithSize:self.game.homeTeam.logoUrl andSize:@"42x42"]];
  }

  self.summary.text = self.contentInfo[summaryLocation];
}

@end
