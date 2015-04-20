//
//  CSAlwaysOnTopHeader.m
//  CSStickyHeaderFlowLayoutDemo
//
//  Created by Mike Silvis on 6/4/14.
//  Copyright (c) 2014 Mike Silvis. All rights reserved.
//

#import "SBLeagueCollectionViewCell.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "SBUser.h"
#import "SBConstants.h"
#import "CSStickyHeaderFlowLayoutAttributes.h"
#import "SBConstants.h"
#import "UIImage+ImageEffects.h"
#import <Mixpanel.h>
#import <ReactiveCocoa.h>


@interface SBLeagueCollectionViewCell ()

@property (nonatomic, assign) BOOL firedMixpanelEvent;

@end

@implementation SBLeagueCollectionViewCell

- (void)awakeFromNib {
  [super awakeFromNib];

  [self declareBindings];
}

- (void)declareBindings {

}

- (void)applyLayoutAttributes:(CSStickyHeaderFlowLayoutAttributes *)layoutAttributes {
  CGFloat yOrigin = CGRectGetMinY(layoutAttributes.frame);

  bool hidden = yOrigin >= -1 ? NO : YES;

  [[UIApplication sharedApplication] setStatusBarHidden:hidden];
  [[NSNotificationCenter defaultCenter] postNotificationName:kNotificationHideEvent object:@{
                                                                                               @"alpha" : [NSNumber numberWithBool:hidden]
                                                                                              }];
  [UIView animateWithDuration:0.3 animations:^{
    if (hidden) {
      if (!self.firedMixpanelEvent) {
        [[Mixpanel sharedInstance] track:@"usedParallax"];
        self.firedMixpanelEvent = YES;
      }
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
  self.tintBackground.alpha = 0;

  NSString *userDefaultsKey = [[SBUser currentUser] keyForFavoriteTeam:self.league.name];
  @weakify(self)
  [[[NSUserDefaults standardUserDefaults] rac_channelTerminalForKey:userDefaultsKey] subscribeNext:^(id x) {
    @strongify(self);
    [self updateHeader];
  }];
}

- (void)updateHeader {
  @weakify(self);
  [self.headerImage sd_setImageWithURL:self.league.header
                      placeholderImage:[UIImage imageNamed:kPlaceholderImage] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                        @strongify(self);
                        UIColor *tintColor = [[UIColor blackColor] colorWithAlphaComponent:0.5];
                        self.headerImageBlurred.image = [image applyBlurWithRadius:20 tintColor:tintColor saturationDeltaFactor:1.8 maskImage:nil];
                        self.backgroundColor = [UIColor whiteColor];
                        if (![self.league isEnabled]) {
                          self.tintBackground.alpha = 0.6;
                        }
  }];

}

@end
