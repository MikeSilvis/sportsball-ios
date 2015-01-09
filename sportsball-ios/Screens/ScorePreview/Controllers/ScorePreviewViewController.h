//
//  ScorePreviewViewController.h
//  sportsball-ios
//
//  Created by Mike Silvis on 1/8/15.
//  Copyright (c) 2015 Mike Silvis. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SportsBallModalViewController.h"
#import "Game.h"
#import "ZFModalTransitionAnimator.h"

@interface ScorePreviewViewController : SportsBallModalViewController <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) UIVisualEffectView *blurView;
@property (weak, nonatomic) IBOutlet UIImageView *awayTeamLogo;
@property (weak, nonatomic) IBOutlet UIImageView *homeTeamLogo;
@property (weak, nonatomic) IBOutlet UIButton *closeButton;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *loadingIndicator;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end
