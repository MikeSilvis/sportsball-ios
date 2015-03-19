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

//  [self buildTabbar];
  [self addScores];
  [self addStandings];
}

- (void)addScores {
  if (!self.scoresView) {
    self.scoresView = [[[NSBundle mainBundle] loadNibNamed:@"SBScoreIndexView" owner:nil options:nil] lastObject];
    self.scoresView.frame = self.bounds;
    self.scoresView.league = self.league;
    [self addSubview:self.scoresView];
  }
}

- (void)addStandings {
  if (!self.standingsView) {
    self.standingsView = [[[NSBundle mainBundle] loadNibNamed:@"SBStandingsView" owner:nil options:nil] lastObject];
    self.standingsView.frame = self.bounds;
    self.standingsView.league = self.league;
    self.standingsView.hidden = YES;
    [self addSubview:self.standingsView];
  }
}

- (void)setLeague:(SBLeague *)league {
  _league = league;

  self.scoresView.league    = self.league;
  self.standingsView.league = self.league;
}


#pragma mark - Timers

- (void)cancelTimer {
  [self.standingsView cancelTimer];
  [self.scoresView cancelTimer];
}

- (void)startTimer {
  if (!self.standingsView.hidden) {
    [self.standingsView startTimer];
  }
  if (!self.scoresView.hidden) {
    [self.scoresView startTimer];
  }
}


@end
