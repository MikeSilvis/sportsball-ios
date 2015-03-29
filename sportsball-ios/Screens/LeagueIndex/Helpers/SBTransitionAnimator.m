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
  destinationViewController.view.alpha = 0.0;
  [containerView addSubview:destinationViewController.view];

  [UIView animateWithDuration:0.4 animations:^{

    [self moveCells:parentController];
    [self hideCells:parentController];

    // Hide Cells
  } completion:^(BOOL finished) {
    destinationViewController.view.alpha = 1.0;
    [transitionContext completeTransition:YES];
  }];
}

- (void)moveCells:(SBLeagueIndexViewController *)parentController {
  if ([parentController.collectionView.visibleCells count] > 0) {
    UICollectionViewCell *cell = parentController.collectionView.visibleCells[parentController.selectedIndexPath.row];
    CGRect cellFrame = [parentController.collectionView convertRect:cell.frame toView:parentController.view];
    CGRect f = parentController.collectionView.frame;
    f.origin.y = f.origin.y - cellFrame.origin.y;
    parentController.collectionView.frame = f;
  }
}

- (void)hideCells:(SBLeagueIndexViewController *)parentController {
  [parentController.collectionView.visibleCells enumerateObjectsUsingBlock:^(UICollectionViewCell *cell, NSUInteger idx, BOOL *stop) {
    if (idx != parentController.selectedIndexPath.row) {
      cell.alpha = 0.0;
    }
  }];
}

- (void)dismissAddEntryViewController:(UIViewController *)destinationViewController fromParentViewController:(SBLeagueIndexViewController *)parentController usingContainerView:(UIView *)containerView transitionContext: (id<UIViewControllerContextTransitioning>)transitionContext {
  parentController.view.alpha = 1.0;
  destinationViewController.view.alpha = 0.0;
  [parentController.collectionView reloadData];
  [self moveCells:parentController];
  [self hideCells:parentController];

  [UIView animateWithDuration:0.4 animations:^{
    // Move Collection view to top
    CGRect f = parentController.collectionView.frame;
    f.origin.y = 0;
    parentController.collectionView.frame = f;

    // Show Cells
    [parentController.collectionView.visibleCells enumerateObjectsUsingBlock:^(UICollectionViewCell *cell, NSUInteger idx, BOOL *stop) {
      cell.alpha = 1.0;
    }];
  } completion:^(BOOL finished) {
    [transitionContext completeTransition:YES];
  }];
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
