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

  [self setStats];
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

- (void)setStats {
  NSArray *stats = self.team.stats;
  NSUInteger statsCount = [stats count];

  // One
  int positionNumber = 0;
  if (statsCount > positionNumber) {
    self.statOne.text = stats[positionNumber];
  }
  else {
    self.statOne.text = nil;
  }

  // Two
  positionNumber = 1;
  if (statsCount > positionNumber) {
    self.statTwo.text = stats[positionNumber];
  }
  else {
    self.statTwo.text = nil;
  }

  // Three
  positionNumber = 2;
  if (statsCount > positionNumber) {
    self.statThree.text = stats[positionNumber];
  }
  else {
    self.statThree.text = nil;
  }

  // Four
  positionNumber = 3;
  if (statsCount > positionNumber) {
    self.statFour.text = stats[positionNumber];
  }
  else {
    self.statFour.text = nil;
  }

  // Five
  positionNumber = 4;
  if (statsCount > positionNumber) {
    self.statFive.text = stats[positionNumber];
  }
  else {
    self.statFive.text = nil;
  }
}

@end
