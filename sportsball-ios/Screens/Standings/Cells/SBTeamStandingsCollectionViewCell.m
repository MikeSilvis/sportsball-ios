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

@end
