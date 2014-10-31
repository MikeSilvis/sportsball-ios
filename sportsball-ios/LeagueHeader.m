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
  [UIView beginAnimations:@"" context:nil];

  if (layoutAttributes.progressiveness <= 0.58) {
    [self animateTitleAndHeader:1];
  } else {
    [self animateTitleAndHeader:0];
  }

  [UIView commitAnimations];
}

-(void)animateTitleAndHeader:(CGFloat)value {
  self.titleLabel.alpha = value;
//  self.headerBackground.alpha = value;
}

@end
