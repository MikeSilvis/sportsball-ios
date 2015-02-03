//
//  SBViewController.m
//  sportsball-ios
//
//  Created by Mike Silvis on 12/27/14.
//  Copyright (c) 2014 Mike Silvis. All rights reserved.
//

#import "SBViewController.h"
#import "XHRealTimeBlur.h"
#import <MPGNotification.h>
#import "SBUser.h"

@implementation SBViewController

- (void)viewDidLoad {
  [super viewDidLoad];
  self.view.layer.contents = (id)[UIImage imageNamed:@"background"].CGImage;
}

- (void)didStartLoading {
  [self.view showRealTimeBlurWithBlurStyle:XHBlurStyleTranslucent];

  if (!self.activityView) {
    self.activityView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
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
  [self.view disMissRealTimeBlur];

  if (self.activityView) {
    self.activityView.hidden = YES;
    [self.activityView removeFromSuperview];
  }
}

- (void)showNetworkError:(NSError *)error {
  MPGNotification *notification = [MPGNotification notificationWithHostViewController:self
                                                                                title:[[SBUser currentUser] networkConnectionErrorMessage:nil]
                                                                             subtitle:nil
                                                                      backgroundColor:[UIColor redColor]
                                                                            iconImage:[[SBUser currentUser] networkConnectionErrorIcon]];
  notification.animationType = MPGNotificationAnimationTypeDrop;
  [notification show];
}

@end