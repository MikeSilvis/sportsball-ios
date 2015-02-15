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

@implementation SBLeagueIndexHeader

- (void)setLeague:(SBLeague *)league {
  _league = league;

  NSURL *logoUrl = league.logo;
  if ([SBUser currentUser].leagueLogos) {
    logoUrl = league.secondaryLogo;
  }

  [self.logoImage sd_setImageWithURL:[league imageURL:logoUrl withSize:@"100x100"]];
  
  [self.backgroundImage sd_setImageWithURL:[league imageURL:league.blurredHeader withSize:@"1000x563"]
                                 completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {

                                   if ([SBUser currentUser].leagueLogos) {
                                     UIColor *blackColor = [[UIColor blackColor] colorWithAlphaComponent:0.5];
                                     image = [UIImage colorizeImage:image withColor:blackColor];
                                   }

                                   self.backgroundImage.image = image;
  }];
}

@end
