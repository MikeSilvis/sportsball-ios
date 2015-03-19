//
//  SBTabBarView.h
//  sportsball-ios
//
//  Created by Mike Silvis on 3/18/15.
//  Copyright (c) 2015 Mike Silvis. All rights reserved.
//

#import "SBLeague.h"
#import "SBScoreIndexView.h"
#import "SBStandingsView.h"

@protocol SBTabBarDelegate <NSObject>

- (void)selectedGame:(SBGame *)game;
- (void)askForFavoriteTeam:(SBTeam *)team;
- (void)requestFailed:(NSError *)error;

@end

@interface SBTabBarView : UIView <UITabBarDelegate, SBScoreIndexViewDelegate>

@property (nonatomic, strong) SBLeague *league;
@property (nonatomic, strong) SBStandingsView *standingsView;
@property (nonatomic, strong) SBScoreIndexView *scoresView;
@property (nonatomic, weak) id<SBTabBarDelegate> delegate;

- (void)cancelTimer;
- (void)startTimer;
- (void)selectedTab:(NSString *)selectedItemText;

@end