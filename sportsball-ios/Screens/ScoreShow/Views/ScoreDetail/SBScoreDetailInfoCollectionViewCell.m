//
//  ScoreDetailInfoCollectionViewCell.m
//  sportsball-ios
//
//  Created by Mike Silvis on 12/4/14.
//  Copyright (c) 2014 Mike Silvis. All rights reserved.
//

#import "SBScoreDetailInfoCollectionViewCell.h"
#import <SDWebImage/UIImageView+WebCache.h>

@implementation SBScoreDetailInfoCollectionViewCell

- (void)awakeFromNib {
  [super awakeFromNib];
  self.backgroundColor = [UIColor clearColor];
}

- (void)setContentInfo:(NSArray *)contentInfo {
  _contentInfo = contentInfo;

  NSString *teamDataName = self.contentInfo[0];
  SBTeam *currentTeam = [self.game teamFromDataName:teamDataName];
  [self.teamLogo sd_setImageWithURL:[currentTeam imageURL:currentTeam.logoUrl withSize:@"42x42"]];

  self.time.text = self.contentInfo[1];
  self.summary.text = self.contentInfo[2];
}

@end