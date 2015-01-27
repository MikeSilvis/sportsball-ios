//
//  ScoreShowViewController.h
//  sportsball-ios
//
//  Created by Mike Silvis on 11/13/14.
//  Copyright (c) 2014 Mike Silvis. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SBGame.h"
#import "SBBoxscore.h"
#import "SBModalViewController.h"

@interface SBScoreShowViewController : SBModalViewController <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) SBBoxscore *boxscore;

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (weak, nonatomic) IBOutlet UIImageView *homeTeamLogo;
@property (weak, nonatomic) IBOutlet UILabel *homeTeamScore;

@property (weak, nonatomic) IBOutlet UIImageView *awayTeamLogo;
@property (weak, nonatomic) IBOutlet UILabel *awayTeamScore;

@property (weak, nonatomic) IBOutlet UIButton *closeButton;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *loadingIndicator;
@property (weak, nonatomic) IBOutlet UILabel *location;

@end
