//
//  SBViewController.h
//  sportsball-ios
//
//  Created by Mike Silvis on 12/27/14.
//  Copyright (c) 2014 Mike Silvis. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SBViewController : UIViewController

@property (nonatomic, strong) UIActivityIndicatorView *activityView;

- (void)didStartLoading;
- (void)didEndLoading;
- (void)showNetworkError:(NSError *)error;

@end
