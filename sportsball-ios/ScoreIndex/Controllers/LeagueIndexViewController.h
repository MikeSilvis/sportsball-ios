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
#import "ScoreShowViewController.h"

@interface LeagueIndexViewController : UIViewController <APPaginalTableViewDataSource, APPaginalTableViewDelegate, ScoreIndexViewDelegate, ScoreShowViewDelegate>

@property (nonatomic, strong) APPaginalTableView *paginalTableView;
@property (nonatomic, strong) UIPageControl *pageControl;
@property (nonatomic, strong) NSArray *leagues;
@property (nonatomic, strong) NSMutableArray *scoreViews;
@property (nonatomic, strong) UIActivityIndicatorView *activityView;
@property (weak, nonatomic) IBOutlet UIToolbar *toolBar;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *hamburgerButton;
@property (nonatomic, strong) Game *selectedGame;
@property (nonatomic, strong) ZFModalTransitionAnimator *animator;

- (IBAction)didRequestClose:(id)sender;

-(void)openScoresAtIndex:(NSUInteger)index animated:(BOOL)animated;

@end
