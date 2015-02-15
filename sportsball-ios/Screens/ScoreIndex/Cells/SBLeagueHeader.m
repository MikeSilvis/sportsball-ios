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

- (void)applyLayoutAttributes:(UICollectionViewLayoutAttributes *)layoutAttributes {
  [UIView animateWithDuration:0.1 animations:^{
    CGFloat yOrigin = CGRectGetMinY(layoutAttributes.frame);
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

- (void)setCurrentLeague:(SBLeague *)currentLeague {
  _currentLeague = currentLeague;

  NSURL *logoUrl = self.currentLeague.logo;
  if ([SBUser currentUser].leagueLogos) {
    logoUrl = self.currentLeague.secondaryLogo;
  }

  [self.smallLogo sd_setImageWithURL:[self.currentLeague imageURL:logoUrl withSize:@"100x100"]];

  [self.headerImage sd_setImageWithURL:[self.currentLeague imageURL:self.currentLeague.header withSize:@"1000x563"]];
  [self.headerImageBlurred sd_setImageWithURL:[self.currentLeague imageURL:self.currentLeague.blurredHeader withSize:@"1000x563"]];
}

@end
