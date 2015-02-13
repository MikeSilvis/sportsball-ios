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

@interface SBModalViewController ()

@property (nonatomic, strong) ZFModalTransitionAnimator *animator;

@end

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

  SVModalWebViewController *webViewController = [[SVModalWebViewController alloc] initWithURL:url];
  webViewController.title = @"";

  // Transition
  self.animator = [[ZFModalTransitionAnimator alloc] initWithModalViewController:webViewController];
  self.animator.direction = ZFModalTransitonDirectionRight;
  self.animator.dragable = YES;

  // set transition delegate of modal view controller to our object
  webViewController.transitioningDelegate = self.animator;
  webViewController.modalPresentationStyle = UIModalPresentationCustom;

  [self presentViewController:webViewController animated:YES completion:NULL];
}

- (void)showNetworkError:(NSError *)error {
  MPGNotification *notification = [MPGNotification notificationWithHostViewController:self
                                                                                title:[[SBUser currentUser] networkConnectionErrorMessage:nil]
                                                                             subtitle:nil
                                                                      backgroundColor:[UIColor colorWithRed:0.910 green:0.278 blue:0.128 alpha:1.000]
                                                                            iconImage:[[SBUser currentUser] networkConnectionErrorIcon]];
  notification.animationType = MPGNotificationAnimationTypeDrop;
  [notification show];
}

@end
