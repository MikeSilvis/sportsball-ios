//
//  CSAlwaysOnTopHeader.m
//  CSStickyHeaderFlowLayoutDemo
//
//  Created by Mike Silvis on 6/4/14.
//  Copyright (c) 2014 Mike Silvis. All rights reserved.
//

#import "SBLeagueHeader.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "SBUser.h"
#import "SBConstants.h"
#import "CSStickyHeaderFlowLayoutAttributes.h"
#import "SBConstants.h"
#import "UIImageView+LBBlurredImage.h"


@implementation SBLeagueHeader

- (void)applyLayoutAttributes:(CSStickyHeaderFlowLayoutAttributes *)layoutAttributes {
  CGFloat yOrigin = CGRectGetMinY(layoutAttributes.frame);

  bool hidden = yOrigin >= -1 ? NO : YES;
  [[NSNotificationCenter defaultCenter] postNotificationName:kNotificationHideEvent object:@{
                                                                                               @"alpha" : [NSNumber numberWithBool:hidden]
                                                                                              }];
  [UIView animateWithDuration:0.3 animations:^{
    if (hidden) {
      self.leagueText.alpha = 0.0;
      self.headerImage.alpha = 1.0;
    }
    else {
      self.leagueText.alpha = 1.0;
      self.headerImage.alpha = 0.0;
    }
  }];
}

- (void)setLeague:(SBLeague *)currentLeague {
  _league = currentLeague;
  self.leagueText.text = self.league.englishName;
  
  if (![self.league isEnabled]) {
    self.tintBackground.alpha = 0.6;
  }
  else {
    self.tintBackground.alpha = 0;
  }
  
  [self.headerImage sd_setImageWithURL:[self.league imageURL:self.league.header withSize:kPlaceholderImageSize]
                      placeholderImage:[UIImage imageNamed:kPlaceholderImage] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                        [self.headerImageBlurred setImageToBlur:image blurRadius:kLBBlurredImageDefaultBlurRadius completionBlock:nil];
  }];
}

@end
