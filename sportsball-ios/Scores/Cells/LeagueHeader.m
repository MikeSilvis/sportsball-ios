//
//  CSAlwaysOnTopHeader.m
//  CSStickyHeaderFlowLayoutDemo
//
//  Created by James Tang on 6/4/14.
//  Copyright (c) 2014 Jamz Tang. All rights reserved.
//

#import "LeagueHeader.h"
#import "CSStickyHeaderFlowLayoutAttributes.h"
#import "UIImage+Blur.h"

@implementation LeagueHeader

-(void)awakeFromNib {
  [super awakeFromNib];
}

- (void)applyLayoutAttributes:(CSStickyHeaderFlowLayoutAttributes *)layoutAttributes {
  if (!self.blurredImage) {
    [self createBlurredImage];
  }

  [UIView animateWithDuration:0.1 animations:^{
    CGFloat yOrigin = layoutAttributes.frame.origin.y;
    if (yOrigin == 0) {
      self.smallLogo.alpha = 1;
    }
    else if (yOrigin >= -10) {
      self.smallLogo.alpha = 0.75;
    }
    else if (yOrigin >= -20) {
      self.smallLogo.alpha = 0.5;
    }
    else if (yOrigin >= -30) {
      self.smallLogo.alpha = 0.25;
    }
    else if (yOrigin >= -40) {
      self.smallLogo.alpha = 0;
    }
  }];

  [UIView animateWithDuration:0.1 animations:^{
    if (layoutAttributes.frame.origin.y >= -20) {
      self.largeLogo.image = self.blurredImage;
    } else {
      self.largeLogo.image = self.largeLogoImage;
    }
  }];
}

-(void)setCurrentLeague:(League *)currentLeague {
  _currentLeague = currentLeague;

  self.largeLogo.image = [UIImage imageNamed:self.currentLeague.header];
  self.smallLogo.image = [UIImage imageNamed:self.currentLeague.logo];

  // Re-add the blur
  [self createBlurredImage];
  self.largeLogo.image = self.blurredImage;
}

-(void)createBlurredImage {
  self.largeLogoImage = self.largeLogo.image;
  self.blurredImage = self.currentLeague.blurredHeader;
}

@end
