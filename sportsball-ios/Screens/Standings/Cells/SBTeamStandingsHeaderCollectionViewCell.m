//
//  SBTeamStandingsHeaderCollectionViewCell.m
//  sportsball-ios
//
//  Created by Mike Silvis on 3/17/15.
//  Copyright (c) 2015 Mike Silvis. All rights reserved.
//

#import "SBTeamStandingsHeaderCollectionViewCell.h"
#import "SBScoreSummaryInfoCollectionViewCell.h"

@implementation SBTeamStandingsHeaderCollectionViewCell

static NSString * const kScoreSummaryinfoCell = @"kScoreSummaryinfoCell";
static int const kCellRowHeight = 25;

- (void)awakeFromNib {
  [super awakeFromNib];

  self.collectionView.backgroundColor = [UIColor clearColor];
  [self.collectionView registerNib:[UINib nibWithNibName:@"ScoreSummaryInfoViewCell" bundle:nil] forCellWithReuseIdentifier:kScoreSummaryinfoCell];
}

- (void)setStanding:(SBStanding *)standing {
  _standing = standing;

  [self.collectionView reloadData];
}

#pragma mark - UICollectionView

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
  NSArray *itemsForSection = self.standing.headers;

  CGFloat collectionViewWidth = self.collectionView.bounds.size.width;
  CGFloat smallerItemWidth = 40;
  CGFloat largeritemWidth = collectionViewWidth - (smallerItemWidth * ([itemsForSection count] -1));

  CGFloat width = (indexPath.row == 0) ? largeritemWidth : smallerItemWidth;

  return CGSizeMake(width, kCellRowHeight);
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
  // +1 for header title
  return ([self.standing.headers count] + 1);
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
  SBScoreSummaryInfoCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kScoreSummaryinfoCell forIndexPath:indexPath];

  cell.indexPath = indexPath;
  cell.outerIndexPath = self.indexPath;
  cell.standing = self.standing;

  return cell;
}

@end
