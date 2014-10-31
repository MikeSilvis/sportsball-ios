//
//  CSAlwaysOnTopHeader.m
//  CSStickyHeaderFlowLayoutDemo
//
//  Created by James Tang on 6/4/14.
//  Copyright (c) 2014 Jamz Tang. All rights reserved.
//

#import "LeagueHeader.h"
#import "CSStickyHeaderFlowLayoutAttributes.h"

@implementation LeagueHeader

- (void)applyLayoutAttributes:(CSStickyHeaderFlowLayoutAttributes *)layoutAttributes {
  [UIView animateWithDuration:0.3 animations:^{
    if (layoutAttributes.progressiveness <= 0.1) {
      self.backgroundColor = [UIColor blackColor];
      self.smallLogo.alpha = 1;
      self.largeLogo.alpha = 0;
    } else {
      self.backgroundColor = [UIColor clearColor];
      self.smallLogo.alpha = 0;
      self.largeLogo.alpha = 1;
    }
  }];
}

-(void)animateTitleAndHeader:(CGFloat)value {
  self.titleLabel.alpha = value;
//  self.headerBackground.alpha = value;
}

@end
