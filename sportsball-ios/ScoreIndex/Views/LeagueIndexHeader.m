//
//  LeagueIndexHeader.m
//  sportsball-ios
//
//  Created by Mike Silvis on 11/6/14.
//  Copyright (c) 2014 Mike Silvis. All rights reserved.
//

#import "LeagueIndexHeader.h"
#import "CSStickyHeaderFlowLayoutAttributes.h"
#import "UIImage+Blur.h"

@implementation LeagueIndexHeader

-(void)setLeague:(League *)league {
  _league = league;

  self.backgroundImage.image = league.blurredHeader;
  self.logoImage.image = [UIImage imageNamed:league.logo];
}


@end
