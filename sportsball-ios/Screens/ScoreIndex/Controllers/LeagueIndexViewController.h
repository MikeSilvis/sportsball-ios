//
//  LeagueViewController.h
//  sportsball-ios
//
//  Created by Mike Silvis on 11/6/14.
//  Copyright (c) 2014 Mike Silvis. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "APPaginalTableView.h"
#import "ScoreIndexView.h"
#import "ZFModalTransitionAnimator.h"
#import "SportsBallModalViewController.h"
#import "SportsBallViewController.h"
#import "LeagueIndexHeader.h"
#import <MessageUI/MessageUI.h> 
#import <MessageUI/MFMailComposeViewController.h>

@interface LeagueIndexViewController : SportsBallViewController <APPaginalTableViewDataSource, APPaginalTableViewDelegate, ScoreIndexViewDelegate, SportsBallModalDelegate, MFMailComposeViewControllerDelegate>

@property (nonatomic, strong) APPaginalTableView *paginalTableView;
@property (nonatomic, strong) UIPageControl *pageControl;
@property (nonatomic, copy) NSArray *leagues;
@property (nonatomic, strong) NSMutableArray *scoreViews;
@property (weak, nonatomic) IBOutlet UIToolbar *toolBar;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *hamburgerButton;
@property (nonatomic, strong) SBGame *selectedGame;
@property (nonatomic, strong) ZFModalTransitionAnimator *animator;
@property (weak, nonatomic) IBOutlet UIButton *supportButton;
- (IBAction)supportRequestClicked:(id)sender;

- (IBAction)didRequestClose:(id)sender;

-(void)openScoresAtIndex:(NSUInteger)index animated:(BOOL)animated;

@end
