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

- (void)awakeFromNib {
  [super awakeFromNib];

  self.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0.5f];
}

- (void)setCurrentLeague:(SBLeague *)currentLeague {
  _currentLeague = currentLeague;
  self.leagueText.text = self.currentLeague.englishName;

  [self.headerImage sd_setImageWithURL:[self.currentLeague imageURL:self.currentLeague.header withSize:kPlaceholderImageSize]];
  [self.headerImageBlurred sd_setImageWithURL:[self.currentLeague imageURL:self.currentLeague.blurredHeader withSize:kPlaceholderImageSize] placeholderImage:[UIImage imageNamed:kPlaceholderImage]];
}

@end
