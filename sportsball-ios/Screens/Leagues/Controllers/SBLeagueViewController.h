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

@interface SBLeagueViewController : SBViewController <UITabBarDelegate, UICollectionViewDelegate, UICollectionViewDataSource, UIViewControllerTransitioningDelegate>

@property (weak, nonatomic) IBOutlet UIButton *supportButton;
// Has to be a collection view because of SBLeagueHeader
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (nonatomic, strong) NSIndexPath *selectedIndexPath;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;

@end
