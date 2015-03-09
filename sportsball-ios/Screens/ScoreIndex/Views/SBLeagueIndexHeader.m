//
//  LeagueIndexHeader.m
//  sportsball-ios
//
//  Created by Mike Silvis on 11/6/14.
//  Copyright (c) 2014 Mike Silvis. All rights reserved.
//

#import "SBLeagueIndexHeader.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "UIImage+ColorImage.h"
#import "SBUser.h"
#import "SBConstants.h"

@implementation SBLeagueIndexHeader

- (void)setLeague:(SBLeague *)league {
  _league = league;

  NSURL *logoUrl = league.secondaryLogo;
  if ([SBUser currentUser].leagueLogos) {
    logoUrl = league.logo;
  }

  [self.logoImage sd_setImageWithURL:[league imageURL:logoUrl withSize:@"100x100"]];

  [self.backgroundImage sd_setImageWithURL:[league imageURL:league.blurredHeader withSize:kPlaceholderImageSize]
                          placeholderImage:[UIImage imageNamed:kPlaceholderImage]];
}

@end
