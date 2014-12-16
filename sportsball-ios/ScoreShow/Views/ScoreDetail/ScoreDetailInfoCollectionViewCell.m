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

  NSString *teamDataName = self.contentInfo[1];

  if ([self.game.awayTeam.dataName isEqualToString:teamDataName]) {
    [self.teamLogo setImageWithURL:self.game.awayTeam.logoUrl];
  }
  else if ([self.game.homeTeam.dataName isEqualToString:teamDataName]) {
    [self.teamLogo setImageWithURL:self.game.homeTeam.logoUrl];
  }

  self.time.text = self.contentInfo[0];
  self.summary.text = self.contentInfo[2];
}

@end
