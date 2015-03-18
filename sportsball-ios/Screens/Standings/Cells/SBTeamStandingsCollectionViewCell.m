//
//  SBTeamStandingsCollectionViewCell.m
//  sportsball-ios
//
//  Created by Mike Silvis on 3/17/15.
//  Copyright (c) 2015 Mike Silvis. All rights reserved.
//

#import "SBTeamStandingsCollectionViewCell.h"
#import "SBUser.h"
#import <SDWebImage/UIImageView+WebCache.h>

@implementation SBTeamStandingsCollectionViewCell

- (void)awakeFromNib {
  [super awakeFromNib];

  self.backgroundColor = [UIColor clearColor];
}

- (void)setTeam:(SBTeam *)team {
  _team = team;

  self.teamName.text = self.team.name;

  if ([SBUser currentUser].teamLogos) {
    [self.teamLogo sd_setImageWithURL:[self.team imageURL:self.team.logoUrl withSize:@"50x50"]];
  }
}

- (void)layoutSubviews {
  [super layoutSubviews];

  // Upper Border
  CALayer *upperBorder = [CALayer layer];
  upperBorder.backgroundColor = [[UIColor whiteColor] CGColor];
  CGFloat totalWidth = CGRectGetWidth(self.frame);
  CGFloat width = totalWidth;
  CGFloat widthOfBorder = 0.5f;
  upperBorder.frame = CGRectMake((totalWidth - width) / 2, self.bounds.size.height - widthOfBorder, width, widthOfBorder);
  upperBorder.opacity = 0.5f;
  [self.layer addSublayer:upperBorder];
}

@end
