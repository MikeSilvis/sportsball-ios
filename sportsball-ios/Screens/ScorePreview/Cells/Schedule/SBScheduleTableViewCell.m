//
//  ScheduleTableViewCell.m
//  sportsball-ios
//
//  Created by Mike Silvis on 1/13/15.
//  Copyright (c) 2015 Mike Silvis. All rights reserved.
//

#import "SBScheduleTableViewCell.h"
#import "SBScheduleInfoTableViewCell.h"
#import <UIImageView+AFNetworking.h>
#import "Underscore.h"
#import "SBUser.h"
#import "SBScoreDetailHeaderCollectionViewCell.h"

@implementation SBScheduleTableViewCell

static int const kCellRowHeight = 40;
static NSString * const kScheduleInfoViewCell = @"kScheduleInfoViewCell";

static int const kCellRowHeaderHeight = 20;
static NSString * const kScoreDetailHeaderCell = @"scoreDetailHeaderCollectionViewCell";

-(void)awakeFromNib {
  [super awakeFromNib];

  self.backgroundColor = [UIColor clearColor];
  self.contentView.backgroundColor = [UIColor clearColor];

  self.tableView.backgroundColor = [UIColor clearColor];
  self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;

  // Register Nibs
    [self.tableView registerNib:[UINib nibWithNibName:@"ScheduleInfoTableViewCell" bundle:nil]
         forCellReuseIdentifier:kScheduleInfoViewCell];

    [self.tableView registerNib:[UINib nibWithNibName:@"ScoreDetailHeaderCollectionViewCell" bundle:nil] forHeaderFooterViewReuseIdentifier:kScoreDetailHeaderCell];
}

-(void)setCurrentTeam:(SBTeam *)currentTeam {
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
  SBScheduleInfoTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kScheduleInfoViewCell forIndexPath:indexPath];
  cell.schedule = [self schedule][indexPath.row];

  return cell;
}

-(NSArray *)schedule {
  return [self.game.preview scheduleForTeam:self.currentTeam];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
  return kCellRowHeight;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
  if ([[SBUser currentUser].lastOpenedLeague.isMonthlySchedule boolValue]) {
    SBScoreDetailHeaderCollectionViewCell *cell = [tableView dequeueReusableHeaderFooterViewWithIdentifier:kScoreDetailHeaderCell];
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

  if ([[SBUser currentUser].lastOpenedLeague.isMonthlySchedule boolValue]) {
    height = height + kCellRowHeaderHeight;
  }

  height = height + [schedules count] * kCellRowHeight;

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
