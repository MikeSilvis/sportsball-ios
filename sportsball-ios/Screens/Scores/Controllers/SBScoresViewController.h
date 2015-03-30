//
//  SBScoresViewController.h
//  sportsball-ios
//
//  Created by Mike Silvis on 3/27/15.
//  Copyright (c) 2015 Mike Silvis. All rights reserved.
//

#import "SBViewController.h"
#import "SBLeague.h"
#import "SBPagingViewController.h"
#import "ZFModalTransitionAnimator.h"

@interface SBScoresViewController : SBViewController <SBPagingViewDelegate>

@property (nonatomic, strong) SBLeague *league;
@property (nonatomic, strong) ZFModalTransitionAnimator *animator;
@property (weak, nonatomic) IBOutlet UIView *containerView;

@end
