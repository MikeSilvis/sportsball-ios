//
//  LeagueIndexHeader.m
//  sportsball-ios
//
//  Created by Mike Silvis on 11/6/14.
//  Copyright (c) 2014 Mike Silvis. All rights reserved.
//

#import "SBLeagueIndexHeader.h"
#import "CSStickyHeaderFlowLayoutAttributes.h"
#import "UIImage+Blur.h"
#import <AFNetworking/UIImageView+AFNetworking.h>

@implementation SBLeagueIndexHeader

- (void)setLeague:(SBLeague *)league {
  _league = league;

  [self.backgroundImage setImageWithURL:[league imageURL:league.blurredHeader withSize:@"1000x563"]];
  [self.logoImage setImageWithURL:[league imageURL:league.logo withSize:@"100x100"]];
}


@end