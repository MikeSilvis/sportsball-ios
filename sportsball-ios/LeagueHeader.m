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
#define RAND_FROM_TO(min, max) (min + arc4random_uniform(max - min + 1))

@implementation LeagueHeader

-(void)awakeFromNib {
  [super awakeFromNib];
  CGFloat number = RAND_FROM_TO(1, 5);
  NSString *imageName = [NSString stringWithFormat:@"nhl-header-%f", number];
  self.largeLogo.image = [UIImage imageNamed:imageName];
}

- (void)applyLayoutAttributes:(CSStickyHeaderFlowLayoutAttributes *)layoutAttributes {
  if (!self.blurredImage) {
    [self createBlurredImage];
  }

  [UIView animateWithDuration:0.3 animations:^{
    if (layoutAttributes.progressiveness <= 0.1) {
      self.smallLogo.alpha = 1;
      self.largeLogo.image = self.blurredImage;
    } else {
      self.smallLogo.alpha = 0;
      self.largeLogo.image = self.largeLogoImage;
    }
  }];

}

-(void)createBlurredImage {
  self.largeLogoImage = self.largeLogo.image;

  float quality = .00001f;
  float blurred = 2.5f;

  NSData *imageData = UIImageJPEGRepresentation(self.largeLogoImage, quality);
  UIImage *blurredImage = [[UIImage imageWithData:imageData] blurredImage:blurred];

  self.blurredImage = blurredImage;
}

@end
