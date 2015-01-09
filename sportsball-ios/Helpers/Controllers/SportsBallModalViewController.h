//
//  SportsBallModalViewController.h
//  sportsball-ios
//
//  Created by Mike Silvis on 1/8/15.
//  Copyright (c) 2015 Mike Silvis. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Game.h"
#import "SVModalWebViewController.h"
#import "ZFModalTransitionAnimator.h"

@protocol SportsBallModalDelegate <NSObject>

-(void)dismissedScoreShowViewModal;

@end

@interface SportsBallModalViewController : UIViewController

@property (nonatomic, weak) id<SportsBallModalDelegate> delegate;
@property (nonatomic, strong) UIVisualEffectView *blurView;
@property (nonatomic, strong) Game *game;

-(void)openURL:(NSURL *)url;

@end
