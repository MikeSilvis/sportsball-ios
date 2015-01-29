//
//  LeagueIndexHeader.m
//  sportsball-ios
//
//  Created by Mike Silvis on 11/6/14.
//  Copyright (c) 2014 Mike Silvis. All rights reserved.
//

#import "SBLeagueIndexHeader.h"
#import <SDWebImage/UIImageView+WebCache.h>

@implementation SBLeagueIndexHeader

- (void)setLeague:(SBLeague *)league {
  _league = league;

  [self.backgroundImage sd_setImageWithURL:[league imageURL:league.blurredHeader withSize:@"1000x563"]];
  [self.logoImage sd_setImageWithURL:[league imageURL:league.logo withSize:@"100x100"]];
}

@end
