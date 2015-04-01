//
//  SBScoresViewController.h
//  sportsball-ios
//
//  Created by Mike Silvis on 3/27/15.
//  Copyright (c) 2015 Mike Silvis. All rights reserved.
//

#import "SBViewController.h"
#import "ZFModalTransitionAnimator.h"

@protocol SBPagingViewDelegate <NSObject>

- (UIViewController *)viewControllerAtIndex:(NSUInteger)index;

@end

@interface SBPagingViewController : SBViewController

@property (nonatomic, strong) ZFModalTransitionAnimator *animator;
@property (nonatomic, weak) id<SBPagingViewDelegate> delegate;

@end
