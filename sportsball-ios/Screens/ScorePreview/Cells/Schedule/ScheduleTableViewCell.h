//
//  ScheduleTableViewCell.h
//  sportsball-ios
//
//  Created by Mike Silvis on 1/13/15.
//  Copyright (c) 2015 Mike Silvis. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Game.h"

@interface ScheduleTableViewCell : UITableViewCell <UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) Game *game;
@property (weak, nonatomic) IBOutlet UISegmentedControl *segmentedControl;

+(CGSize)measureCellSizeWithResource:(Game *)game andWidth:(CGFloat)width;

@end
