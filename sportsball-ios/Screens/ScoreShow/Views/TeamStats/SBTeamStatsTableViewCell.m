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

  [self.tableView registerNib:[UINib nibWithNibName:@"SBTeamStatInfoTableViewCell" bundle:nil]
       forCellReuseIdentifier:kTeamStatInfoCell];
}

- (void)setGameStats:(SBGameStats *)gameStats {
  _gameStats = gameStats;

  [self.tableView reloadData];
}

#pragma mark - UITableView

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
  return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
  return kCellRowHeight;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
//  return [self.gameStats.headers count];
  return 10;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  NSLog(@"HERE");
  SBTeamStatInfoTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kTeamStatInfoCell forIndexPath:indexPath];

  return cell;
}

#pragma mark - Measurements

+ (CGSize)measureCellSizeWithResource:(NSArray *)resource andWidth:(CGFloat)width {
  return CGSizeMake(width, 100);
}

@end
