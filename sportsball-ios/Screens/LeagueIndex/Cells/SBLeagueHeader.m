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

@implementation SBLeagueHeader

- (void)applyLayoutAttributes:(CSStickyHeaderFlowLayoutAttributes *)layoutAttributes {
  [UIView animateWithDuration:0.3 animations:^{
    CGFloat yOrigin = CGRectGetMinY(layoutAttributes.frame);

    float alpha = yOrigin >= -50 ? 1 : 0;

    self.leagueText.alpha = alpha;
    self.headerImage.alpha = !alpha;

//    bool hidden = ![[NSNumber numberWithFloat:alpha] boolValue];
//    [[UIApplication sharedApplication] setStatusBarHidden:hidden];
//    [[NSNotificationCenter defaultCenter] postNotificationName:kNotificationHideEvent object:@{
//                                                                                               @"alpha" : [NSNumber numberWithBool:hidden]
//                                                                                              }];
  }];
}

- (void)awakeFromNib {
  self.backgroundColor = [UIColor purpleColor];
}

- (void)layoutSubviews {
  [super layoutSubviews];

  // Lower Border
  CALayer *upperBorder = [CALayer layer];
  upperBorder.backgroundColor = [[UIColor whiteColor] CGColor];
  CGFloat totalWidth = CGRectGetWidth(self.frame);
  CGFloat width = totalWidth;
  CGFloat widthOfBorder = 0.5f;
  upperBorder.frame = CGRectMake((totalWidth - width) / 2, self.bounds.size.height - widthOfBorder, width, widthOfBorder);
  upperBorder.opacity = 0.5f;
  [self.layer addSublayer:upperBorder];
}

- (void)setCurrentLeague:(SBLeague *)currentLeague {
  _currentLeague = currentLeague;
  self.leagueText.text = self.currentLeague.englishName;

  [self.headerImage sd_setImageWithURL:[self.currentLeague imageURL:self.currentLeague.header withSize:kPlaceholderImageSize]];
  [self.headerImageBlurred sd_setImageWithURL:[self.currentLeague imageURL:self.currentLeague.blurredHeader withSize:kPlaceholderImageSize] placeholderImage:[UIImage imageNamed:kPlaceholderImage]];
}

@end
