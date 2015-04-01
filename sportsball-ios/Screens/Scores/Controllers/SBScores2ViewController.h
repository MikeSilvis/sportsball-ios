//
//  SBScores2ViewController.h
//  sportsball-ios
//
//  Created by Mike Silvis on 3/31/15.
//  Copyright (c) 2015 Mike Silvis. All rights reserved.
//

#import "SBViewController.h"
#import "SBLeague.h"
#import "DIDatepicker.h"
#import "SBGame.h"
#import "SBLeagueHeader.h"
#import "SBDatePickerCollectionViewCell.h"
#import "ZFModalTransitionAnimator.h"
#import "SBModalViewController.h"

@interface SBScores2ViewController : UIViewController <SBDatePickerCollectionViewCellDelegate>

@property NSUInteger pageIndex;
@property CGRect parentRect;
@property (nonatomic, strong) SBLeague *league;
@property (nonatomic, strong) ZFModalTransitionAnimator *animator;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;

@end
