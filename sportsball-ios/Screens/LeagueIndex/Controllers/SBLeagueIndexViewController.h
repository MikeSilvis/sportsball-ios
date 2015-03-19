//
//  LeagueViewController.h
//  sportsball-ios
//
//  Created by Mike Silvis on 11/6/14.
//  Copyright (c) 2014 Mike Silvis. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "APPaginalTableView.h"
#import "SBScoreIndexView.h"
#import "ZFModalTransitionAnimator.h"
#import "SBModalViewController.h"
#import "SBViewController.h"
#import "SBTabBarView.h"
#import "SBLeagueIndexHeader.h"

@interface SBLeagueIndexViewController : SBViewController <APPaginalTableViewDataSource, APPaginalTableViewDelegate, SBTabBarDelegate, SportsBallModalDelegate, UITabBarDelegate>

@property (weak, nonatomic) IBOutlet UIToolbar *toolBar;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *hamburgerButton;
@property (weak, nonatomic) IBOutlet UIButton *supportButton;

@property (nonatomic, strong) APPaginalTableView *paginalTableView;
@property (nonatomic, strong) SBGame *selectedGame;
@property (nonatomic, strong) ZFModalTransitionAnimator *animator;
@property (nonatomic, strong) UIPageControl *pageControl;
@property (nonatomic, copy) NSArray *leagues;
@property (nonatomic, strong) NSMutableArray *leagueTabViews;
@property BOOL isNotificationOpen;
@property (weak, nonatomic) IBOutlet UITabBar *tabBar;

- (IBAction)didRequestClose:(id)sender;

@end
