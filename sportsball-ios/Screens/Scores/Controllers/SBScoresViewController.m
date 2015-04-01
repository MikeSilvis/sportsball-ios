//
//  SBScoresViewController.m
//  sportsball-ios
//
//  Created by Mike Silvis on 3/27/15.
//  Copyright (c) 2015 Mike Silvis. All rights reserved.
//

#import "SBScoresViewController.h"
#import "SBModalViewController.h"
#import "SBBoxscoreViewController.h"
#import "SBPreviewViewController.h"
#import "SBModalViewController.h"
#import "SBScores2ViewController.h"

#import "SBUser.h"
#import <MPGNotification.h>
#import "EDColor.h"

@interface SBScoresViewController () <UIPageViewControllerDataSource>

@property (nonatomic, strong) UIPageViewController *pageViewController;

@end

@implementation SBScoresViewController

static NSString * const kScoreIndexViewCell = @"scoreIndexViewCell";
static NSString * const kPagingSegue = @"pagingSegue";
static  NSString *kScoreShowSegue = @"scoreShowSegue";
static  NSString *kScorePreviewSegue = @"kScorePreviewSegue";

#pragma mark - Page View Controller Data Source

- (void)viewDidLoad {
  [super viewDidLoad];

  // Create page view controller
  self.pageViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"PageContentViewController"];
  self.pageViewController.dataSource = self;

  UIViewController *scoresViewController = [self viewControllerAtIndex:[self openedIndex]];
  [self.pageViewController setViewControllers:@[scoresViewController] direction:UIPageViewControllerNavigationDirectionForward animated:NO completion:nil];

  // Change the size of page view controller
  self.pageViewController.view.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height - self.tabBarController.tabBar.frame.size.height);

  [self addChildViewController:self.pageViewController];
  [self.view addSubview:self.pageViewController.view];
  [self.pageViewController didMoveToParentViewController:self];
}

- (int)openedIndex {
  int openedIndex = [[SBUser currentUser].lastOpenedLeagueIndex intValue];
  if ((openedIndex >= 0) && ([SBUser currentUser].leagues[openedIndex])) {
    return openedIndex;
  }
  else {
    return 0;
  }
}

#pragma mark - Page View Controller Data Source

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(UIViewController *)viewController {
  NSUInteger index = ((SBScores2ViewController*) viewController).pageIndex;

  if ((index == 0) || (index == NSNotFound)) {
    return nil;
  }
  index--;
  return [self viewControllerAtIndex:index];
}

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(UIViewController *)viewController {
  NSUInteger index = ((SBScores2ViewController*) viewController).pageIndex;

  if (index == NSNotFound) {
    return nil;
  }

  index++;
  if (index == [[SBUser currentUser].leagues count]) {
    return nil;
  }

  return [self viewControllerAtIndex:index];
}

- (SBScores2ViewController *)viewControllerAtIndex:(NSUInteger)index {
  if (([[SBUser currentUser].leagues count] == 0) || (index >= [[SBUser currentUser].leagues count])) {
    return nil;
  }

  SBScores2ViewController *pageContentViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"SBScoresView2Controller"];
  pageContentViewController.pageIndex = index;
  pageContentViewController.parentRect = self.view.frame;
  pageContentViewController.league = [SBUser currentUser].leagues[index];

  [SBUser currentUser].lastOpenedLeagueIndex = @(index);

  return pageContentViewController;
}

- (NSInteger)presentationCountForPageViewController:(UIPageViewController *)pageViewController {
  return [[SBUser currentUser].leagues count];
}

- (NSInteger)presentationIndexForPageViewController:(UIPageViewController *)pageViewController {
  return [self openedIndex];
}


@end
