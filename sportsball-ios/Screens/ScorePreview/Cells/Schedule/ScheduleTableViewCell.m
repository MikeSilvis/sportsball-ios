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

@implementation ScheduleTableViewCell

static int const cellRowHeight = 40;
static NSString * const scheduleInfoViewCell = @"scheduleInfoViewCell";

-(void)awakeFromNib {
  [super awakeFromNib];

  self.backgroundColor = [UIColor clearColor];
  self.contentView.backgroundColor = [UIColor clearColor];

  self.tableView.backgroundColor = [UIColor clearColor];
  self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;

  // Register Nibs
  [self.tableView registerNib:[UINib nibWithNibName:@"ScheduleInfoTableViewCell" bundle:nil]
       forCellReuseIdentifier:scheduleInfoViewCell];
}

-(void)setCurrentTeam:(Team *)currentTeam {
  _currentTeam = currentTeam;

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

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
  return [[self schedule] count];
}

#pragma mark - Measure

+(CGSize)measureCellSizeWithResource:(NSArray *)schedules andWidth:(CGFloat)width {
  CGFloat height = 50;

  height = height + [schedules count] * cellRowHeight;

  return CGSizeMake(width, height);
}

@end
