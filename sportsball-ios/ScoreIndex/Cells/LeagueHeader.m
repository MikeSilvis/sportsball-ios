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

- (void)applyLayoutAttributes:(CSStickyHeaderFlowLayoutAttributes *)layoutAttributes {
  [UIView animateWithDuration:0.1 animations:^{
    CGFloat yOrigin = layoutAttributes.frame.origin.y;
    if (yOrigin >= 0) {
      float alpha = 1;

      self.smallLogo.alpha = alpha;
      self.headerImageBlurred.alpha = alpha;
    }
    else if (yOrigin >= -5) {
      float alpha = 0.90;

      self.smallLogo.alpha = alpha;
      self.headerImageBlurred.alpha = alpha;
    }
    else if (yOrigin >= -10) {
      float alpha = 0.75;

      self.smallLogo.alpha = alpha;
      self.headerImageBlurred.alpha = alpha;
    }
    else if (yOrigin >= -20) {
      float alpha = 0.5;

      self.smallLogo.alpha = alpha;
      self.headerImageBlurred.alpha = alpha;
    }
    else if (yOrigin >= -30) {
      float alpha = 0;

      self.smallLogo.alpha = alpha;
      self.headerImageBlurred.alpha = alpha;
    }
  }];
}

-(void)setCurrentLeague:(League *)currentLeague {
  _currentLeague = currentLeague;

  self.headerImage.image = [UIImage imageNamed:self.currentLeague.header];
  self.smallLogo.image = [UIImage imageNamed:self.currentLeague.logo];
  self.headerImageBlurred.image = self.currentLeague.blurredHeader;
}

@end
