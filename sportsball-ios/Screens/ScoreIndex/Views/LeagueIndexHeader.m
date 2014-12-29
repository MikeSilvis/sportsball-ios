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
#import <AFNetworking/UIImageView+AFNetworking.h>

@implementation LeagueIndexHeader

-(void)setLeague:(League *)league {
  _league = league;

  [self.backgroundImage setImageWithURL:[league imageURLWithSize:league.blurredHeader andSize:@"1000x563"]];
  [self.logoImage setImageWithURL:[league imageURLWithSize:league.logo andSize:@"100x100"]];
}


@end
