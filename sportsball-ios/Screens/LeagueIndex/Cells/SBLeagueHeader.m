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

@interface SBLeagueHeader ()

@property (nonatomic, strong) CALayer *lowerBoarder;

@end

@implementation SBLeagueHeader

- (void)applyLayoutAttributes:(CSStickyHeaderFlowLayoutAttributes *)layoutAttributes {
  [UIView animateWithDuration:0.3 animations:^{
    CGFloat yOrigin = CGRectGetMinY(layoutAttributes.frame);

    bool hidden = yOrigin >= -50 ? NO : YES;

    self.leagueText.hidden = hidden;
    self.headerImage.hidden = !hidden;

//    bool hidden = ![[NSNumber numberWithFloat:alpha] boolValue];
    [[UIApplication sharedApplication] setStatusBarHidden:hidden];
//    [[NSNotificationCenter defaultCenter] postNotificationName:kNotificationHideEvent object:@{
//                                                                                               @"alpha" : [NSNumber numberWithBool:hidden]
//                                                                                              }];
  }];
}

- (void)layoutSubviews {
  [super layoutSubviews];

  if (!self.lowerBoarder) {
    self.lowerBoarder = [CALayer layer];
    self.lowerBoarder.backgroundColor = [[UIColor whiteColor] CGColor];
    self.lowerBoarder.opacity = 0.5f;
    [self.layer addSublayer:self.lowerBoarder];
  }

  CGFloat totalWidth = CGRectGetWidth(self.frame);
  CGFloat width = totalWidth;
  CGFloat widthOfBorder = 0.5f;
  self.lowerBoarder.frame = CGRectMake((totalWidth - width) / 2, self.bounds.size.height - widthOfBorder, width, widthOfBorder);
}

- (void)setCurrentLeague:(SBLeague *)currentLeague {
  _currentLeague = currentLeague;
  self.leagueText.text = self.currentLeague.englishName;

  [self.headerImage sd_setImageWithURL:[self.currentLeague imageURL:self.currentLeague.header withSize:kPlaceholderImageSize]];
  [self.headerImageBlurred sd_setImageWithURL:[self.currentLeague imageURL:self.currentLeague.blurredHeader withSize:kPlaceholderImageSize] placeholderImage:[UIImage imageNamed:kPlaceholderImage]];
}

@end
