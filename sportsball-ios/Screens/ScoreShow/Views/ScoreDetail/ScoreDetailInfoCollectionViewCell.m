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

  NSString *teamDataName = self.contentInfo[0];
  Team *currentTeam = [self.game teamFromDataName:teamDataName];
  [self.teamLogo setImageWithURL:[currentTeam imageURLWithSize:currentTeam.logoUrl andSize:@"42x42"]];

  self.time.text = self.contentInfo[1];
  self.summary.text = self.contentInfo[2];
}

@end
