//
//  SBTransitionAnimator.m
//  sportsball-ios
//
//  Created by Mike Silvis on 3/27/15.
//  Copyright (c) 2015 Mike Silvis. All rights reserved.
//

#import "SBTransitionAnimator.h"
#import "SBLeagueIndexViewController.h"

@implementation SBTransitionAnimator

static const NSTimeInterval AnimationDuration = 0.25;

- (NSTimeInterval)transitionDuration:(id<UIViewControllerContextTransitioning>)transitionContext {
  return AnimationDuration;
}

- (void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext {
    id fromViewController = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];

    id toViewController = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];

    UIView *containerView = [transitionContext containerView];

    if (self.presenting) {
      [self presentDestinationViewController:toViewController overParentViewController:fromViewController usingContainerView:containerView transitionContext:transitionContext];
    }
    else {
      [self dismissAddEntryViewController:fromViewController fromParentViewController:toViewController usingContainerView:containerView transitionContext:transitionContext];
    }
}

- (void)presentDestinationViewController:(UIViewController *)destinationViewController overParentViewController:(SBLeagueIndexViewController *)parentController usingContainerView:(UIView *)containerView transitionContext:(id<UIViewControllerContextTransitioning>)transitionContext {
  // Hide Cells
  [self transformCells:parentController.collectionView.visibleCells
              duration:0.8
             withBlock:^(UICollectionViewCell *cell, NSUInteger idx) {
      if (idx != parentController.selectedIndexPath.row) {
        cell.alpha = 0.0;
      }
  }];

  destinationViewController.view.alpha = 0.0;
  [containerView addSubview:destinationViewController.view];

  // Move selected row to the top
  [UIView animateWithDuration:0.8 animations:^{
    UICollectionViewCell *cell = parentController.collectionView.visibleCells[parentController.selectedIndexPath.row];
    // Update Cell Frame
//    CGRect f = cell.frame;
//    f.size.height = 74;
//    cell.frame = f;

    CGRect cellFrame = [parentController.collectionView convertRect:cell.frame toView:parentController.view];
    CGRect f = parentController.collectionView.frame;
    f.origin.y = f.origin.y - cellFrame.origin.y;
    parentController.collectionView.frame = f;
  } completion:^(BOOL finished) {
//    [UIView animateWithDuration:0.1 animations:^{
//      destinationViewController.view.alpha = 1.0;
//    }];
      destinationViewController.view.alpha = 1.0;
    [transitionContext completeTransition:YES];
  }];
}

- (void)transformCells:(NSArray *)cells duration:(double)duration withBlock:(void (^)(UICollectionViewCell *cell, NSUInteger idx))block {
  [UIView animateWithDuration:duration animations:^{
    [cells enumerateObjectsUsingBlock:^(UICollectionViewCell *cell, NSUInteger idx, BOOL *stop) {
      block(cell, idx);
    }];
  }];
}

- (void)dismissAddEntryViewController:(UIViewController *)addEntryController fromParentViewController:(UIViewController *)parentController usingContainerView:(UIView *)containerView transitionContext: (id<UIViewControllerContextTransitioning>)transitionContext {
  [containerView addSubview:parentController.view];
  [containerView addSubview:addEntryController.view];
}

- (id<UIViewControllerAnimatedTransitioning>)animationControllerForPresentedController:(UIViewController *)presented presentingController:(UIViewController *)presenting sourceController:(UIViewController *)source {
  SBTransitionAnimator *animator = [[SBTransitionAnimator alloc] init];
  animator.presenting = YES;

  return animator;
}

- (id<UIViewControllerAnimatedTransitioning>) animationControllerForDismissedController:(UIViewController *)dismissed {
  SBTransitionAnimator *animator = [[SBTransitionAnimator alloc] init];
  animator.presenting = NO;

  return animator;
}


@end
