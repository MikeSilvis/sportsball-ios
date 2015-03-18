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

  self.leagueText.text = self.league.englishName;

  [self.backgroundImage sd_setImageWithURL:[league imageURL:league.blurredHeader withSize:kPlaceholderImageSize]
                          placeholderImage:[UIImage imageNamed:kPlaceholderImage]];
}

@end
