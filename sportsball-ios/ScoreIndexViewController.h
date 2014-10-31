//
//  ScoreIndexViewController.h
//  sportsball-ios
//
//  Created by Mike Silvis on 10/31/14.
//  Copyright (c) 2014 Mike Silvis. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Team.h"
#import "Game.h"
#import "HeaderTableViewCell.h"
#import "GameTableViewCell.h"

@interface ScoreIndexViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, retain) NSArray *games;

@end
