//
//  ScheduleTableViewCell.m
//  sportsball-ios
//
//  Created by Mike Silvis on 1/13/15.
//  Copyright (c) 2015 Mike Silvis. All rights reserved.
//

#import "ScheduleTableViewCell.h"
#import "ScheduleInfoTableViewCell.h"
#import <UIImageView+AFNetworking.h>
#import "Underscore.h"
#import "User.h"
#import "ScoreDetailHeaderCollectionViewCell.h"

@implementation ScheduleTableViewCell

static int const cellRowHeight = 40;
static NSString * const scheduleInfoViewCell = @"scheduleInfoViewCell";

static int const cellRowHeaderHeight = 20;
static NSString * const scoreDetailHeaderCell = @"scoreDetailHeaderCollectionViewCell";

-(void)awakeFromNib {
  [super awakeFromNib];

  self.backgroundColor = [UIColor clearColor];
  self.contentView.backgroundColor = [UIColor clearColor];

  self.tableView.backgroundColor = [UIColor clearColor];
  self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;

  // Register Nibs
  [self.tableView registerNib:[UINib nibWithNibName:@"ScheduleInfoTableViewCell" bundle:nil]
       forCellReuseIdentifier:scheduleInfoViewCell];

  [self.tableView registerNib:[UINib nibWithNibName:@"ScoreDetailHeaderCollectionViewCell" bundle:nil] forHeaderFooterViewReuseIdentifier:scoreDetailHeaderCell];
}

-(void)setCurrentTeam:(Team *)currentTeam {
  _currentTeam = currentTeam;

  if (![self schedule]) {
    self.hidden = YES;
  }
  else {
    self.hidden = NO;
  }

  [self.tableView reloadData];
}

#pragma mark - Table Methods

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  ScheduleInfoTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:scheduleInfoViewCell forIndexPath:indexPath];
  cell.schedule = [self schedule][indexPath.row];

  return cell;
}

-(NSArray *)schedule {
  return [self.game.preview scheduleForTeam:self.currentTeam];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
  return cellRowHeight;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
  if ([[User currentUser].lastOpenedLeague.isMonthlySchedule boolValue]) {
    ScoreDetailHeaderCollectionViewCell *cell = [tableView dequeueReusableHeaderFooterViewWithIdentifier:scoreDetailHeaderCell];
    cell.label.text = [self.monthFormatter stringFromDate:[NSDate date]];

    return cell;
  }

  return nil;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
  return [[self schedule] count];
}

#pragma mark - Measure

+(CGSize)measureCellSizeWithResource:(NSArray *)schedules andWidth:(CGFloat)width {
  CGFloat height = 20;

  if ([[User currentUser].lastOpenedLeague.isMonthlySchedule boolValue]) {
    height = height + cellRowHeaderHeight;
  }

  height = height + [schedules count] * cellRowHeight;

  return CGSizeMake(width, height);
}

-(NSDateFormatter *)monthFormatter {
  if (!_monthFormatter) {
    _monthFormatter = [[NSDateFormatter alloc] init];
    [_monthFormatter setDateFormat:@"MMMM"];
    [_monthFormatter setTimeZone:[NSTimeZone localTimeZone]];
  }

  return _monthFormatter;
}

@end
