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
#import <AFNetworking/UIImageView+AFNetworking.h>

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

  [self.smallLogo setImageWithURL:[self.currentLeague imageURLWithSize:self.currentLeague.logo andSize:@"100x100"]];
  [self.headerImage setImageWithURL:[self.currentLeague imageURLWithSize:self.currentLeague.header andSize:@"1000x563"]];
  [self.headerImageBlurred setImageWithURL:[self.currentLeague imageURLWithSize:self.currentLeague.blurredHeader andSize:@"1000x563"]];
}

@end