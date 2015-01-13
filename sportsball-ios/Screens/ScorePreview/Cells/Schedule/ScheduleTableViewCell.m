//
//  ScheduleTableViewCell.m
//  sportsball-ios
//
//  Created by Mike Silvis on 1/13/15.
//  Copyright (c) 2015 Mike Silvis. All rights reserved.
//

#import "ScheduleTableViewCell.h"
#import "ScheduleInfoTableViewCell.h"

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

-(void)setGame:(Game *)game {
  _game = game;

  [self.tableView reloadData];
  [self setupSegmentedControl];
}

-(void)setupSegmentedControl {
  [self.segmentedControl setTitle:self.game.awayTeam.name forSegmentAtIndex:0];
  [self.segmentedControl setTitle:self.game.homeTeam.name forSegmentAtIndex:1];
}

#pragma mark - Table Methods

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  ScheduleInfoTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:scheduleInfoViewCell forIndexPath:indexPath];

  return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
  return cellRowHeight;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
  return self.game.preview.awayTeamSchedule.count;
}

#pragma mark - Measure

+(CGSize)measureCellSizeWithResource:(Game *)game andWidth:(CGFloat)width {
  CGFloat height = 50;

  height = height + [game.preview.awayTeamSchedule count] * cellRowHeight;

  return CGSizeMake(width, height);
}

@end
