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

- (void)awakeFromNib {
  [super awakeFromNib];

  // Logo Gesture
  UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(logoClicked)];
  singleTap.numberOfTapsRequired = 1;
  [self.smallLogo setUserInteractionEnabled:YES];
  [self.smallLogo addGestureRecognizer:singleTap];
}

- (void)logoClicked {
  [self.delegate logoClicked];
}

- (void)applyLayoutAttributes:(CSStickyHeaderFlowLayoutAttributes *)layoutAttributes {
  [UIView animateWithDuration:0.3 animations:^{
    CGFloat yOrigin = CGRectGetMinY(layoutAttributes.frame);

    float alpha = yOrigin >= -50 ? 1 : 0;

    self.smallLogo.alpha = alpha;
    self.headerImageBlurred.alpha = alpha;

    bool hidden = ![[NSNumber numberWithFloat:alpha] boolValue];
    [[UIApplication sharedApplication] setStatusBarHidden:hidden];
    [[NSNotificationCenter defaultCenter] postNotificationName:kNotificationHideEvent object:@{
                                                                                               @"alpha" : [NSNumber numberWithBool:hidden]
                                                                                              }];
  }];
}

- (void)setCurrentLeague:(SBLeague *)currentLeague {
  _currentLeague = currentLeague;

  NSURL *logoUrl = self.currentLeague.secondaryLogo;
  if ([SBUser currentUser].leagueLogos) {
    logoUrl = self.currentLeague.logo;
  }

  [self.smallLogo sd_setImageWithURL:[self.currentLeague imageURL:logoUrl withSize:@"100x100"]];

  [self.headerImageBlurred sd_setImageWithURL:[self.currentLeague imageURL:self.currentLeague.blurredHeader withSize:kPlaceholderImageSize] placeholderImage:[UIImage imageNamed:kPlaceholderImage]];
  [self.headerImage sd_setImageWithURL:[self.currentLeague imageURL:self.currentLeague.header withSize:kPlaceholderImageSize]];
}

@end
