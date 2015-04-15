//
//  SBViewController.m
//  sportsball-ios
//
//  Created by Mike Silvis on 12/27/14.
//  Copyright (c) 2014 Mike Silvis. All rights reserved.
//

#import "SBViewController.h"
#import <MPGNotification.h>
#import "SBUser.h"

@implementation SBViewController

- (void)viewDidLoad {
  [super viewDidLoad];

  self.view.layer.contents = (id)[UIImage imageNamed:@"background"].CGImage;
  self.view.backgroundColor = [UIColor clearColor];
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