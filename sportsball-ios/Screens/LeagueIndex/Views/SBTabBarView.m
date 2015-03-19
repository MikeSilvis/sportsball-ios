//
//  SBTabBarView.m
//  sportsball-ios
//
//  Created by Mike Silvis on 3/18/15.
//  Copyright (c) 2015 Mike Silvis. All rights reserved.
//

#import "SBTabBarView.h"

@implementation SBTabBarView

- (void)awakeFromNib {
  [super awakeFromNib];
  
  self.backgroundColor = [UIColor clearColor];

  [self buildTabbar];
  [self addScores];
  [self addScores];
}

- (void)buildTabbar {
  self.tabBar.backgroundColor = [UIColor clearColor];
  [self.tabBar setBackgroundImage:[UIImage new]];
  [self.tabBar setSelectedItem:[self.tabBar.items firstObject]];

}

- (void)addScores {
  if (!self.scoresView) {
    self.scoresView = [[[NSBundle mainBundle] loadNibNamed:@"SBScoreIndexView" owner:nil options:nil] lastObject];
    self.scoresView.frame = [self defaultBounds];
    self.scoresView.league = self.league;
    [self addSubview:self.scoresView];
  }
}

- (void)addStandings {
  if (!self.standingsView) {
    self.standingsView = [[[NSBundle mainBundle] loadNibNamed:@"SBStandingsView" owner:nil options:nil] lastObject];
    self.standingsView.frame = [self defaultBounds];
    self.standingsView.league = self.league;
    [self addSubview:self.standingsView];
  }
}

- (CGRect)defaultBounds {
  return CGRectMake(0, 0, self.bounds.size.width, self.bounds.size.height - self.tabBar.bounds.size.height);
}

- (void)setLeague:(SBLeague *)league {
  _league = self.league;

  self.scoresView.league    = self.league;
  self.standingsView.league = self.league;
}


#pragma mark - Timers

- (void)cancelTimer {

}

- (void)startTimer {

}

#pragma mark - Tab bar

- (void)tabBar:(UITabBar *)tabBar didSelectItem:(UITabBarItem *)item {
  if ([item.title isEqualToString:@"Standings"]) {
    self.standingsView.hidden = NO;
    self.scoresView.hidden    = YES;
  }
  else if ([item.title isEqualToString:@"Scores"]) {
    self.standingsView.hidden = YES;
    self.scoresView.hidden    = NO;
  }

  [self cancelTimer];
  [self startTimer];
}


@end
