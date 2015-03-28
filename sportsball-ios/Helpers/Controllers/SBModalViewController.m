//
//  SBModalViewController.m
//  sportsball-ios
//
//  Created by Mike Silvis on 1/8/15.
//  Copyright (c) 2015 Mike Silvis. All rights reserved.
//

#import <MPGNotification.h>
#import "SBModalViewController.h"
#import "SBUser.h"
#import "SBWebViewController.h"
#import "XHRealTimeBlur.h"

@interface SBModalViewController ()

@property (nonatomic, strong) ZFModalTransitionAnimator *animator;
@property (nonatomic, strong) UIVisualEffectView *blurView;

@end

static  NSString *kWebSegue = @"webViewSegue";

@implementation SBModalViewController

- (void)viewDidLoad {
  [super viewDidLoad];

  self.view.backgroundColor = [UIColor clearColor];

  // Blur effect
  UIBlurEffect *blur = [UIBlurEffect effectWithStyle:UIBlurEffectStyleDark];
  self.blurView = [[UIVisualEffectView alloc] initWithEffect:blur];
  [self.view addSubview:self.blurView];
  [self.view sendSubviewToBack:self.blurView];
}

- (void)viewWillLayoutSubviews {
  [super viewWillLayoutSubviews];

  self.blurView.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
}

- (void)openURL:(NSURL *)url {
  if (!url) {
    return;
  }

  self.selectedURL = url;
  [self performSegueWithIdentifier:kWebSegue sender:self];
}

- (void)showNetworkError:(NSError *)error {
  MPGNotification *notification = [MPGNotification notificationWithHostViewController:self
                                                                                title:[[SBUser currentUser] networkConnectionErrorMessage:error]
                                                                             subtitle:nil
                                                                      backgroundColor:[UIColor colorWithRed:0.910 green:0.278 blue:0.128 alpha:1.000]
                                                                            iconImage:[[SBUser currentUser] networkConnectionErrorIcon]];
  notification.animationType = MPGNotificationAnimationTypeDrop;
  [notification show];
}

- (void)didStartLoading {
  if (!self.activityView) {
    self.activityView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    self.activityView.center = CGPointMake(50, 50);
    self.activityView.frame = self.view.bounds;
    self.activityView.hidesWhenStopped = YES;
    self.activityView.transform = CGAffineTransformMakeScale(2, 2);
    [self.activityView startAnimating];
  }

  [self.view addSubview:self.activityView];
  self.activityView.hidden = NO;
}

- (void)didEndLoading {
  if (self.activityView) {
    self.activityView.hidden = YES;
    [self.activityView removeFromSuperview];
  }
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
  SBWebViewController *viewController = segue.destinationViewController;
  viewController.view.frame = self.view.bounds;
  viewController.url = self.selectedURL;
  self.animator = [[ZFModalTransitionAnimator alloc] initWithModalViewController:viewController];
  self.animator.dragable = YES;
  self.animator.direction = ZFModalTransitonDirectionRight;

  // set transition delegate of modal view controller to our object
  viewController.transitioningDelegate = self.animator;
  viewController.modalPresentationStyle = UIModalPresentationCustom;
}

- (BOOL)shouldRecieveDrag:(UIGestureRecognizer *)gestureRecognizer {
  return YES;
}

@end
