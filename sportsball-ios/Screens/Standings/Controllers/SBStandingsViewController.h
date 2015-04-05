//
//  SBStandingsViewController.h
//  sportsball-ios
//
//  Created by Mike Silvis on 3/28/15.
//  Copyright (c) 2015 Mike Silvis. All rights reserved.
//

#import "SBViewController.h"
#import "SBPagingViewController.h"
#import "SBLeague.h"

@interface SBStandingsViewController : UIViewController

@property (nonatomic, strong) SBLeague *league;
@property NSUInteger pageIndex;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;
@property (weak, nonatomic) IBOutlet UIView *containerView;

@end
