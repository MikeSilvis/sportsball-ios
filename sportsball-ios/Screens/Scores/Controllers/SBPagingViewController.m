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
#import <Mixpanel.h>

@interface SBPagingViewController () <UIPageViewControllerDataSource, UIPageViewControllerDelegate>

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
  self.pageViewController.delegate = self;

  [self addChildViewController:self.pageViewController];
  [self.view insertSubview:self.pageViewController.view belowSubview:self.toolBar];
  [self.pageViewController didMoveToParentViewController:self];

  [self buildHamburgerButton];
  [self buildToolBar];
  [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(hideMenuIems:)
                                               name:kNotificationHideEvent object:nil];
  
  [self askForAppReview];
}

- (void)viewDidAppear:(BOOL)animated {
  [super viewDidAppear:animated];
  
  UIViewController *scoresViewController = [self viewControllerAtIndex:[self openedIndex]];
  [self.pageViewController setViewControllers:@[scoresViewController] direction:UIPageViewControllerNavigationDirectionForward animated:NO completion:nil];
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


  [UIView animateWithDuration:0.3 animations:^{
    if (alphaHidden) {
      self.toolBar.alpha = 0.0;
    }
    else {
      self.toolBar.alpha = 1.0;
    }
  }];
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

#pragma mark - Page View Controller Delegate

- (void)pageViewController:(UIPageViewController *)pageViewController
        didFinishAnimating:(BOOL)finished
   previousViewControllers:(NSArray *)previousViewControllers
       transitionCompleted:(BOOL)completed {

  if (completed) {
    NSUInteger currentIndex = ((SBScoresViewController *)[self.pageViewController.viewControllers firstObject]).pageIndex;
    [SBUser currentUser].lastOpenedLeagueIndex = @(currentIndex);
    [[Mixpanel sharedInstance] track:@"swipedBetweenLeagues"];
  }
}

- (NSInteger)presentationCountForPageViewController:(UIPageViewController *)pageViewController {
  return [[SBUser currentUser].enabledLeagues count];
}

- (NSInteger)presentationIndexForPageViewController:(UIPageViewController *)pageViewController {
  return [self openedIndex];
}

- (IBAction)hamburgerClicked:(id)sender {
  [SBUser currentUser].lastOpenedLeagueIndex = @(-1);
  
  [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)askForAppReview {
  if (![[SBUser currentUser] askForAppReview]) {
    return;
  }
  
  NSString *headerReviewRequest = @"Review us";
  NSString *subtitleReviewRequest = @"You are awesome. Will you please leave us a review?";
  
  CGFloat iconSize = 32;
  FAKFontAwesome *thumbsUpIcon = [FAKFontAwesome thumbsUpIconWithSize:iconSize];
  UIImage *thumbsUpImage = [UIImage imageWithFontAwesomeIcon:thumbsUpIcon andSize:iconSize andColor:@"fff"];

  MPGNotification *notification = [MPGNotification notificationWithHostViewController:self
                                                                                title:headerReviewRequest
                                                                             subtitle:subtitleReviewRequest
                                                                      backgroundColor:[UIColor colorWithHexString:@"274385"]
                                                                            iconImage:thumbsUpImage];
  [notification setButtonConfiguration:MPGNotificationButtonConfigrationTwoButton withButtonTitles:@[@"Yes!", @"No"]];
  notification.animationType = MPGNotificationAnimationTypeDrop;
  notification.swipeToDismissEnabled = NO;
  notification.backgroundTapsEnabled = NO;
  
  [notification showWithButtonHandler:^(MPGNotification *notification, NSInteger buttonIndex) {
    if (buttonIndex == notification.firstButton.tag) {
      [[SBUser currentUser] acceptedAppReview];
      NSString *appStoreURL = [[SBConstants sharedInstance] getSecretValueFrom:@"APP_STORE_URL"];
      [[UIApplication sharedApplication] openURL: [NSURL URLWithString:appStoreURL]];
    }
    else if (buttonIndex == notification.secondButton.tag) {
      [[SBUser currentUser] rejectedAppReview];
    }
  }];
}

@end
