//
//  SBStandingsViewController.m
//  sportsball-ios
//
//  Created by Mike Silvis on 3/28/15.
//  Copyright (c) 2015 Mike Silvis. All rights reserved.
//

#import "SBStandingsViewController.h"
#import "SBUser.h"
#import "SBStandingsViewCell.h"
#import "SBPagingViewController.h"

@interface SBStandingsViewController () <SBPagingViewDelegate>

@end

@implementation SBStandingsViewController

static NSString *kPagingSegue = @"pagingSegue";

- (UIViewController *)viewControllerAtIndex:(NSUInteger)index {
  SBStandingsViewController *pageContentViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"SBStandingsViewController"];
//  SBStandingsViewController.pageIndex = index;
//  SBStandingsViewController.league = [SBUser currentUser].leagues[index];

  [SBUser currentUser].lastOpenedLeagueIndex = @(index);

  return pageContentViewController;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
  if ([segue.identifier isEqualToString:kPagingSegue]) {
    SBPagingViewController *viewController = segue.destinationViewController;
    viewController.delegate = self;
  }
}
@end
