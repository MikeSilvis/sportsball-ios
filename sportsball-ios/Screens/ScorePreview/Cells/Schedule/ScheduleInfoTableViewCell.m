//
//  ScheduleInfoTableViewCell.m
//  sportsball-ios
//
//  Created by Mike Silvis on 1/13/15.
//  Copyright (c) 2015 Mike Silvis. All rights reserved.
//

#import "ScheduleInfoTableViewCell.h"
#import <UIImageView+AFNetworking.h>

@implementation ScheduleInfoTableViewCell

- (void)awakeFromNib {
  [super awakeFromNib];

  self.backgroundColor = [UIColor clearColor];
  self.contentView.backgroundColor = [UIColor clearColor];
  self.selectionStyle = UITableViewCellSelectionStyleNone;
}

-(void)setSchedule:(Schedule *)schedule {
  _schedule = schedule;

  [self.logo setImageWithURL:[schedule.opponent imageURL:schedule.opponent.logoUrl withSize:@"60x60"]];
  self.team.text = schedule.opponent.name;

  if (schedule.isOver) {
    self.score.text = schedule.result;
    self.winOrLoss.hidden = NO;

    if (schedule.isWin) {
      self.winOrLoss.text = @"W";
      self.winOrLoss.textColor = [UIColor greenColor];
    }
    else {
      self.winOrLoss.text = @"L";
      self.winOrLoss.textColor = [UIColor redColor];
    }
  }
  else {
    self.score.text = [schedule.dateFormatter stringFromDate:schedule.startTime];
    self.winOrLoss.hidden = YES;
  }

  self.date.text = [self.dateFormatter stringFromDate:schedule.date];

  if (schedule.isAway) {
    self.isAway.text = @"@";
  }
  else {
    self.isAway.text = @"vs";
  }
}

-(NSDateFormatter *)dateFormatter {
  if (!_dateFormatter) {
    _dateFormatter = [[NSDateFormatter alloc] init];
    [_dateFormatter setDateFormat:@"MM/dd"];
    [_dateFormatter setTimeZone:[NSTimeZone localTimeZone]];
  }

  return _dateFormatter;
}

@end