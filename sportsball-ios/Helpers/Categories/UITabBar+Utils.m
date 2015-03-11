//
//  UIImageView+Utils.m
//  sportsball-ios
//
//  Created by Mike Silvis on 3/10/15.
//  Copyright (c) 2015 Mike Silvis. All rights reserved.
//

#import "UITabBar+Utils.h"

@implementation UITabBar (Utils)

- (void)setImageRenderingMode:(UIImageRenderingMode)renderMode {
  NSAssert(self.backgroundImage, @"Image must be set before setting rendering mode");

  self.selectionIndicatorImage = [self.selectionIndicatorImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
  self.backgroundImage = [self.backgroundImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
}

@end