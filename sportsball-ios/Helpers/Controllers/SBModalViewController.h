//
//  SBModalViewController.h
//  sportsball-ios
//
//  Created by Mike Silvis on 1/8/15.
//  Copyright (c) 2015 Mike Silvis. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SBGame.h"
#import "ZFModalTransitionAnimator.h"

@protocol SportsBallModalDelegate <NSObject>

- (void)dismissedModal;

@end

@interface SBModalViewController : UIViewController

@property (nonatomic, weak) id<SportsBallModalDelegate> delegate;
@property (nonatomic, strong) SBGame *game;
@property (nonatomic, strong) NSURL *selectedURL;
@property (nonatomic, strong) UIActivityIndicatorView *activityView;

- (void)openURL:(NSURL *)url;
- (void)showNetworkError:(NSError *)error;
- (void)didStartLoading;
- (void)didEndLoading;
- (BOOL)shouldRecieveDrag:(UIGestureRecognizer *)gestureRecognizer;

@end
