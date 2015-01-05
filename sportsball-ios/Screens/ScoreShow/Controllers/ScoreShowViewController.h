//
//  ScoreShowViewController.h
//  sportsball-ios
//
//  Created by Mike Silvis on 11/13/14.
//  Copyright (c) 2014 Mike Silvis. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Game.h"
#import "Boxscore.h"

@protocol ScoreShowViewDelegate <NSObject>

-(void)dismissedScoreShowViewModal;

@end

@interface ScoreShowViewController : UIViewController <UIGestureRecognizerDelegate, UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) Game *game;
@property (nonatomic, strong) Boxscore *boxscore;

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) UIVisualEffectView *blurView;

@property (nonatomic, weak) id<ScoreShowViewDelegate> delegate;

@property (weak, nonatomic) IBOutlet UIImageView *homeTeamLogo;
@property (weak, nonatomic) IBOutlet UILabel *homeTeamScore;

@property (weak, nonatomic) IBOutlet UIImageView *awayTeamLogo;
@property (weak, nonatomic) IBOutlet UILabel *awayTeamScore;

@property (weak, nonatomic) IBOutlet UILabel *lowerInfo;
@property (weak, nonatomic) IBOutlet UILabel *upperInfo;
@property (weak, nonatomic) IBOutlet UIButton *closeButton;

@end
