//
//  ScheduleInfoTableViewCell.h
//  sportsball-ios
//
//  Created by Mike Silvis on 1/13/15.
//  Copyright (c) 2015 Mike Silvis. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Schedule.h"

@interface ScheduleInfoTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *date;
@property (weak, nonatomic) IBOutlet UILabel *isAway;
@property (weak, nonatomic) IBOutlet UIImageView *logo;
@property (weak, nonatomic) IBOutlet UILabel *team;
@property (weak, nonatomic) IBOutlet UILabel *score;
@property (weak, nonatomic) IBOutlet UILabel *winOrLoss;
@property (nonatomic, strong) Schedule *schedule;

@property (nonatomic, strong) NSDateFormatter *dateFormatter;

@end
