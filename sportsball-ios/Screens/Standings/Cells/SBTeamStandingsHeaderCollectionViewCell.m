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
static int const kCellRowHeight    = 25;
// If Changing be sure to also update SBTeamStandingsCollectionViewCell items
static int const kSmallerItemWidth = 40;

- (void)awakeFromNib {
  [super awakeFromNib];

  self.collectionView.backgroundColor = [UIColor clearColor];
  [self.collectionView registerNib:[UINib nibWithNibName:@"ScoreSummaryInfoViewCell" bundle:nil] forCellWithReuseIdentifier:kScoreSummaryinfoCell];
}

- (void)setStanding:(SBStanding *)standing {
  _standing = standing;

  [self.collectionView reloadData];
}

- (int)headersCount {
  // +1 for header title
  return (int)([self.standing.headers count] + 1);
}

#pragma mark - UICollectionView

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
  CGFloat collectionViewWidth = self.collectionView.bounds.size.width;
  CGFloat largeritemWidth = collectionViewWidth - ((kSmallerItemWidth * ([self headersCount] - 1)));

  CGFloat width = (indexPath.row == 0) ? largeritemWidth : kSmallerItemWidth;

  return CGSizeMake(width, kCellRowHeight);
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
  return [self headersCount];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
  SBScoreSummaryInfoCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kScoreSummaryinfoCell
                                                                                         forIndexPath:indexPath];

  cell.indexPath = indexPath;
  cell.outerIndexPath = self.indexPath;
  cell.standing = self.standing;

  return cell;
}

- (UIEdgeInsets)collectionView:(UICollectionView*)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
  return UIEdgeInsetsMake(0, 0, 0, 0);
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
  return 0;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
  return 0;
}

@end
