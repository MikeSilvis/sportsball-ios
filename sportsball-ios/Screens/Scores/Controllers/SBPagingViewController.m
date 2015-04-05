//
//  SBScoresViewController.m
//  sportsball-ios
//
//  Created by Mike Silvis on 3/27/15.
//  Copyright (c) 2015 Mike Silvis. All rights reserved.
//

#import "SBPagingViewController.h"
#import "SBModalViewController.h"
#import "SBBoxscoreViewController.h"
#import "SBPreviewViewController.h"
#import "SBModalViewController.h"
#import "SBScoresViewController.h"

#import "SBUser.h"
#import <MPGNotification.h>
#import "EDColor.h"
#import "SBConstants.h"

@interface SBPagingViewController () <UIPageViewControllerDataSource>

@property (nonatomic, strong) UIPageViewController *pageViewController;
@property (weak, nonatomic) IBOutlet UIToolbar *toolBar;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *hamburgerButton;
- (IBAction)hamburgerClicked:(id)sender;

@end

@implementation SBPagingViewController

static NSString * const kScoreIndexViewCell = @"scoreIndexViewCell";
static NSString * const kPagingSegue = @"pagingSegue";
static NSString *kScoreShowSegue = @"scoreShowSegue";
static NSString *kScorePreviewSegue = @"kScorePreviewSegue";

#pragma mark - Page View Controller Data Source

- (void)viewDidLoad {
  [super viewDidLoad];

  // Create page view controller
  self.pageViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"PageContentViewController"];
  self.pageViewController.dataSource = self;

  UIViewController *scoresViewController = [self viewControllerAtIndex:[self openedIndex]];
  [self.pageViewController setViewControllers:@[scoresViewController] direction:UIPageViewControllerNavigationDirectionForward animated:NO completion:nil];

  // Change the size of page view controller
  self.pageViewController.view.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);

  [self addChildViewController:self.pageViewController];
  [self.view insertSubview:self.pageViewController.view belowSubview:self.toolBar];
  [self.pageViewController didMoveToParentViewController:self];

  [self buildHamburgerButton];
  [self buildToolBar];
  [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(hideMenuIems:)
                                               name:kNotificationHideEvent object:nil];
}

- (void)buildHamburgerButton {
  CGFloat iconSize = 25;
  FAKFontAwesome *hamburgerIcon = [FAKFontAwesome barsIconWithSize:iconSize];
  self.hamburgerButton.image = [UIImage imageWithFontAwesomeIcon:hamburgerIcon andSize:iconSize andColor:@"#fff"];
}

- (void)buildToolBar {
  self.toolBar.backgroundColor = [UIColor clearColor];
  [self.toolBar setBackgroundImage:[UIImage new]
                forToolbarPosition:UIToolbarPositionAny
                        barMetrics:UIBarMetricsDefault];
  self.toolBar.clipsToBounds = YES;
}

- (void)hideMenuIems:(NSNotification *)notification {
  bool alphaHidden = [(NSNumber *)notification.object[@"alpha"] boolValue];

  self.toolBar.hidden = alphaHidden;
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
  NSUInteger index = ((SBScoresViewController*) viewController).pageIndex;

  if ((index == 0) || (index == NSNotFound)) {
    return nil;
  }
  index--;
  return [self viewControllerAtIndex:index];
}

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(UIViewController *)viewController {
  NSUInteger index = ((SBScoresViewController*) viewController).pageIndex;

  if (index == NSNotFound) {
    return nil;
  }

  index++;
  if (index == [[SBUser currentUser].leagues count]) {
    return nil;
  }

  return [self viewControllerAtIndex:index];
}

- (UIViewController *)viewControllerAtIndex:(NSUInteger)index {
  if (([[SBUser currentUser].leagues count] == 0) || (index >= [[SBUser currentUser].leagues count])) {
    return nil;
  }

  return [self.delegate viewControllerAtIndex:index];

}

- (NSInteger)presentationCountForPageViewController:(UIPageViewController *)pageViewController {
  return [[SBUser currentUser].leagues count];
}

- (NSInteger)presentationIndexForPageViewController:(UIPageViewController *)pageViewController {
  return [self openedIndex];
}

- (IBAction)hamburgerClicked:(id)sender {
  [SBUser currentUser].lastOpenedLeagueIndex = @(-1);
  
  [self dismissViewControllerAnimated:YES completion:nil];
}
@end
