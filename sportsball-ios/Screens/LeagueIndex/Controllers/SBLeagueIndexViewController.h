//
//  LeagueViewController.h
//  sportsball-ios
//
//  Created by Mike Silvis on 11/6/14.
//  Copyright (c) 2014 Mike Silvis. All rights reserved.
//

#import "ZFModalTransitionAnimator.h"
#import "SBModalViewController.h"
#import "SBViewController.h"
#import "SBTabBarView.h"

@interface SBLeagueIndexViewController : SBViewController <UITabBarDelegate, UICollectionViewDelegate, UICollectionViewDataSource, UIViewControllerTransitioningDelegate>

@property (weak, nonatomic) IBOutlet UIButton *supportButton;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (nonatomic, strong) NSIndexPath *selectedIndexPath;

//@property (nonatomic, strong) SBGame *selectedGame;
//@property (nonatomic, strong) UIPageControl *pageControl;
//@property (nonatomic, strong) NSMutableArray *leagueTabViews;
//@property BOOL isNotificationOpen;
//@property (weak, nonatomic) IBOutlet UIToolbar *toolBar;
//@property (weak, nonatomic) IBOutlet UIBarButtonItem *hamburgerButton;
//@property (weak, nonatomic) IBOutlet UITabBar *tabBar;
//
//- (IBAction)didRequestClose:(id)sender;

@end
