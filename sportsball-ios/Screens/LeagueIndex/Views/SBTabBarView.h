//
//  SBTabBarView.h
//  sportsball-ios
//
//  Created by Mike Silvis on 3/18/15.
//  Copyright (c) 2015 Mike Silvis. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SBLeague.h"
#import "SBScoreIndexView.h"
#import "SBStandingsView.h"

@interface SBTabBarView : UIView <UITabBarDelegate>

@property (nonatomic, strong) SBLeague *league;
@property (weak, nonatomic) IBOutlet UITabBar *tabBar;
@property (nonatomic, strong) SBStandingsView *standingsView;
@property (nonatomic, strong) SBScoreIndexView *scoresView;

- (void)cancelTimer;
- (void)startTimer;

@end
