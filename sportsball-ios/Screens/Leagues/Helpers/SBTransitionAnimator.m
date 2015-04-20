//
//  SBTransitionAnimator.m
//  sportsball-ios
//
//  Created by Mike Silvis on 3/27/15.
//  Copyright (c) 2015 Mike Silvis. All rights reserved.
//

#import "SBTransitionAnimator.h"
#import "SBConstants.h"
#import "SBLeagueViewController.h"
#import "SBLeagueCollectionViewCell.h"
#import "SBUser.h"

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

- (void)presentDestinationViewController:(UIViewController *)destinationViewController overParentViewController:(SBLeagueViewController *)parentController usingContainerView:(UIView *)containerView transitionContext:(id<UIViewControllerContextTransitioning>)transitionContext {
  destinationViewController.view.alpha = 0.0;
  [containerView addSubview:destinationViewController.view];

  [UIView animateWithDuration:0.4 animations:^{

    [self hideCells:parentController];
    [self moveCells:parentController];

    // Hide Cells
  } completion:^(BOOL finished) {
    destinationViewController.view.alpha = 1.0;
    parentController.view.alpha = 0.0;
    [transitionContext completeTransition:YES];
  }];
}

- (void)moveCells:(SBLeagueViewController *)parentController {
  CGFloat cellHeight = kHeaderSize * parentController.selectedIndexPath.row;
  CGRect f = parentController.collectionView.frame;
  f.origin.y = -cellHeight;
  parentController.collectionView.frame = f;
}

- (void)hideCells:(SBLeagueViewController *)parentController {
  SBLeague *selectedLeague = [SBUser currentUser].leagues[parentController.selectedIndexPath.row];

  for (SBLeagueCollectionViewCell *cell in parentController.collectionView.visibleCells) {
    if (![cell.league.name isEqualToString:selectedLeague.name]) {
      cell.alpha = 0.0;
    }
  }
}

- (void)showCells:(SBLeagueViewController *)parentController {
  for (SBLeagueCollectionViewCell *cell in parentController.collectionView.visibleCells) {
    cell.alpha = 1.0;
  }
}

- (void)dismissAddEntryViewController:(UIViewController *)destinationViewController fromParentViewController:(SBLeagueViewController *)parentController usingContainerView:(UIView *)containerView transitionContext: (id<UIViewControllerContextTransitioning>)transitionContext {
  parentController.view.alpha = 1.0;
  destinationViewController.view.alpha = 0.0;
  [self moveCells:parentController];

  [UIView animateWithDuration:0.4 animations:^{
    // Move Collection view to top
    CGRect f = parentController.collectionView.frame;
    f.origin.y = 0;
    parentController.collectionView.frame = f;

    [self showCells:parentController];
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
