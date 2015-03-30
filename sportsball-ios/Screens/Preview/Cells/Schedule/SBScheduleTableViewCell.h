//
//  ScheduleTableViewCell.h
//  sportsball-ios
//
//  Created by Mike Silvis on 1/13/15.
//  Copyright (c) 2015 Mike Silvis. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SBGame.h"

@interface SBScheduleTableViewCell : UITableViewCell <UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) SBGame *game;
@property (nonatomic, strong) SBTeam *currentTeam;
@property (nonatomic, strong) NSDateFormatter *monthFormatter;

+(CGSize)measureCellSizeWithResource:(NSArray *)schedules andWidth:(CGFloat)width;

@end
