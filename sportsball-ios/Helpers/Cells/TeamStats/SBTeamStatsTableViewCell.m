//
//  SBTeamStatsTableViewCell.m
//  sportsball-ios
//
//  Created by Mike Silvis on 1/28/15.
//  Copyright (c) 2015 Mike Silvis. All rights reserved.
//

#import "SBTeamStatsTableViewCell.h"
#import "SBTeamStatInfoTableViewCell.h"

@implementation SBTeamStatsTableViewCell

static int const kCellRowHeight = 30;
static NSString * const kTeamStatInfoCell = @"teamStatInfoCell";

- (void)awakeFromNib {
  [super awakeFromNib];

  self.backgroundColor             = [UIColor clearColor];
  self.contentView.backgroundColor = [UIColor clearColor];
  self.tableView.backgroundColor   = [UIColor clearColor];
  self.tableView.separatorStyle    = UITableViewCellSeparatorStyleNone;
  self.tableView.allowsSelection   = NO;

  [self.tableView registerNib:[UINib nibWithNibName:@"SBTeamStatinfoTableViewCell" bundle:nil]
       forCellReuseIdentifier:kTeamStatInfoCell];
}

- (void)setGameStats:(SBGameStats *)gameStats {
  _gameStats = gameStats;

  if ([self.gameStats.headers count] > 0) {
    self.renderSeperator = YES;
  }

  [self.tableView reloadData];
}

#pragma mark - UITableView

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
  return kCellRowHeight;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
  return [self.gameStats.headers count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  SBTeamStatInfoTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kTeamStatInfoCell forIndexPath:indexPath];
  
  cell.awayStat.text = self.gameStats.awayTeamStats[indexPath.row];
  cell.homeStat.text = self.gameStats.homeTeamStats[indexPath.row];
  cell.stat.text     = self.gameStats.headers[indexPath.row];

  return cell;
}

#pragma mark - Measurements

+ (CGSize)measureCellSizeWithResource:(SBGameStats *)gameStats andWidth:(CGFloat)width {
  return CGSizeMake(width, ([gameStats.headers count] * kCellRowHeight));
}

@end
