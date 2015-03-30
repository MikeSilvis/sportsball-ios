//
//  ScoreDetailCollectionViewCell.m
//  sportsball-ios
//
//  Created by Mike Silvis on 12/4/14.
//  Copyright (c) 2014 Mike Silvis. All rights reserved.
//

#import "SBScoreDetailCollectionViewCell.h"
#import "SBScoreDetailInfoCollectionViewCell.h"
#import "SBScoreDetailHeaderCollectionViewCell.h"

@implementation SBScoreDetailCollectionViewCell

static int const kCellRowHeight = 40;
static NSString * const kScoreDetailInfoCell = @"scoreDetailInfoCollectionViewCell";

static int const kCellRowHeaderHeight = 20;
static NSString * const kScoreDetailHeaderCell = @"scoreDetailHeaderCollectionViewCell";

- (void)awakeFromNib {
  [super awakeFromNib];

  self.backgroundColor = [UIColor clearColor];
  self.tableView.backgroundColor = [UIColor clearColor];
  self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;

  self.selectionStyle = UITableViewCellSelectionStyleNone;

  [self.tableView registerNib:[UINib nibWithNibName:@"SBScoreDetailInfoCollectionViewCell" bundle:nil]
       forCellReuseIdentifier:kScoreDetailInfoCell];

  [self.tableView registerNib:[UINib nibWithNibName:@"SBScoreDetailHeaderCollectionViewCell" bundle:nil] forHeaderFooterViewReuseIdentifier:kScoreDetailHeaderCell];
}

+ (CGSize)measureCellSizeWithResource:(NSArray *)resource andWidth:(CGFloat)width {
  CGFloat height = 20;

  for (SBScoreDetail *scoreDetail in resource) {
    // Header Size
    height = height + kCellRowHeaderHeight;

    // Row size
    height = height + (kCellRowHeight * [scoreDetail.contentInfo count]);
  }

  return CGSizeMake(width, height);
}

- (void)setScoreDetails:(NSArray *)scoreDetails {
  _scoreDetails = scoreDetails;

  self.renderSeperator = ([self.scoreDetails count] > 0);

  [self.tableView reloadData];
}

#pragma mark - UITableView

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
  return kCellRowHeight;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
  return self.scoreDetails.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
  SBScoreDetail *scoreDetail = self.scoreDetails[section];

  return scoreDetail.contentInfo.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  SBScoreDetailInfoCollectionViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kScoreDetailInfoCell forIndexPath:indexPath];

  SBScoreDetail *scoreDetail = self.scoreDetails[indexPath.section];
  cell.game = self.game;
  cell.contentInfo = scoreDetail.contentInfo[indexPath.row];

  return cell;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
  SBScoreDetailHeaderCollectionViewCell *cell = [tableView dequeueReusableHeaderFooterViewWithIdentifier:kScoreDetailHeaderCell];

  SBScoreDetail *scoreDetail = self.scoreDetails[section];
  cell.label.text = scoreDetail.headerInfo;

  return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
  return kCellRowHeaderHeight;
}

@end
