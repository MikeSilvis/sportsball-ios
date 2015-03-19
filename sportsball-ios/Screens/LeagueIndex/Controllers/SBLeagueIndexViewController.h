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
#import "SBLeagueIndexHeader.h"

@interface SBLeagueIndexViewController : SBViewController <APPaginalTableViewDataSource, APPaginalTableViewDelegate, SBScoreIndexViewDelegate, SportsBallModalDelegate>

@property (nonatomic, strong) APPaginalTableView *paginalTableView;
@property (nonatomic, strong) UIPageControl *pageControl;
@property (nonatomic, copy) NSArray *leagues;
@property (nonatomic, strong) NSMutableArray *leagueTabViews;
@property (weak, nonatomic) IBOutlet UIToolbar *toolBar;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *hamburgerButton;
@property (nonatomic, strong) SBGame *selectedGame;
@property (nonatomic, strong) ZFModalTransitionAnimator *animator;
@property (weak, nonatomic) IBOutlet UIButton *supportButton;
@property BOOL isNotificationOpen;

- (IBAction)didRequestClose:(id)sender;
- (void)openScoresAtIndex:(NSUInteger)index animated:(BOOL)animated;

@end
