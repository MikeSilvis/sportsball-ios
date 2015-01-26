//
//  ScoreDetailCollectionViewCell.m
//  sportsball-ios
//
//  Created by Mike Silvis on 12/4/14.
//  Copyright (c) 2014 Mike Silvis. All rights reserved.
//

#import "ScoreDetailCollectionViewCell.h"
#import "ScoreDetail.h"
#import "ScoreDetailInfoCollectionViewCell.h"
#import "ScoreDetailHeaderCollectionViewCell.h"

@implementation ScoreDetailCollectionViewCell

static int const cellRowHeight = 40;
static NSString * const scoreDetailInfoCell = @"scoreDetailInfoCollectionViewCell";

static int const cellRowHeaderHeight = 20;
static NSString * const scoreDetailHeaderCell = @"scoreDetailHeaderCollectionViewCell";

- (void)awakeFromNib {
  [super awakeFromNib];

  self.backgroundColor = [UIColor clearColor];
  self.tableView.backgroundColor = [UIColor clearColor];
  self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;

  self.selectionStyle = UITableViewCellSelectionStyleNone;

  [self.tableView registerNib:[UINib nibWithNibName:@"ScoreDetailInfoCollectionViewCell" bundle:nil]
       forCellReuseIdentifier:scoreDetailInfoCell];

  [self.tableView registerNib:[UINib nibWithNibName:@"ScoreDetailHeaderCollectionViewCell" bundle:nil] forHeaderFooterViewReuseIdentifier:scoreDetailHeaderCell];
}

+ (CGSize)measureCellSizeWithResource:(NSArray *)resource andWidth:(CGFloat)width {
  CGFloat height = 20;

  for (ScoreDetail *scoreDetail in resource) {
    // Header Size
    height = height + cellRowHeaderHeight;

    // Row size
    height = height + (cellRowHeight * [scoreDetail.contentInfo count]);
  }

  return CGSizeMake(width, height);
}

- (void)setScoreDetails:(NSArray *)scoreDetails {
  _scoreDetails = scoreDetails;

  [self.tableView reloadData];
}

#pragma mark - UICollectionView

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
  return cellRowHeight;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
  return self.scoreDetails.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
  ScoreDetail *scoreDetail = self.scoreDetails[section];

  return scoreDetail.contentInfo.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  ScoreDetailInfoCollectionViewCell *cell = [tableView dequeueReusableCellWithIdentifier:scoreDetailInfoCell forIndexPath:indexPath];

  ScoreDetail *scoreDetail = self.scoreDetails[indexPath.section];
  cell.game = self.game;
  cell.contentInfo = scoreDetail.contentInfo[indexPath.row];

  return cell;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
  ScoreDetailHeaderCollectionViewCell *cell = [tableView dequeueReusableHeaderFooterViewWithIdentifier:scoreDetailHeaderCell];

  ScoreDetail *scoreDetail = self.scoreDetails[section];
  cell.label.text = scoreDetail.headerInfo;

  return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
  return cellRowHeaderHeight;
}

@end
