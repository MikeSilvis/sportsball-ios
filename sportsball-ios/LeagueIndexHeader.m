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

  float quality = .00001f;
  float blurred = 2.5f;
  NSData *imageData = UIImageJPEGRepresentation([UIImage imageNamed:league.header], quality);
  UIImage *blurredImage = [[UIImage imageWithData:imageData] blurredImage:blurred];

  self.backgroundImage.image = blurredImage;
  self.logoImage.image = [UIImage imageNamed:league.logo];
}


@end
