//
//  ScoreSummaryCollectionViewCell.m
//  sportsball-ios
//
//  Created by Mike Silvis on 12/4/14.
//  Copyright (c) 2014 Mike Silvis. All rights reserved.
//

#import "SBScoreSummaryViewCell.h"
#import "SBScoreSummaryInfoCollectionViewCell.h"

@implementation SBScoreSummaryViewCell

static NSString * const kScoreSummaryinfoCell = @"kScoreSummaryinfoCell";
static int const kCellRowHeight = 30;
static int const kCellPaddingHeight = 10;

- (void)awakeFromNib {
  [super awakeFromNib];

  self.backgroundColor = [UIColor clearColor];
  self.collectionView.backgroundColor = [UIColor clearColor];
  self.selectionStyle = UITableViewCellSelectionStyleNone;

  [self.collectionView registerNib:[UINib nibWithNibName:@"ScoreSummaryInfoViewCell" bundle:nil] forCellWithReuseIdentifier:kScoreSummaryinfoCell];
}

+ (CGSize)measureCellSizeWithResource:(NSArray *)resource andWidth:(CGFloat)width {
  return CGSizeMake(width, (resource.count * kCellRowHeight) + kCellPaddingHeight);
}

- (void)setGame:(SBGame *)game {
  _game = game;

  self.scoreSummary = self.game.boxscore.scoreSummary;

  self.renderSeperator = !!self.game.boxscore;
}

- (void)setScoreSummary:(NSArray *)scoreSummary {
  _scoreSummary = scoreSummary;

  [self.collectionView reloadData];
}

#pragma mark - UICollectionView

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
  NSArray *itemsForSection = self.scoreSummary[indexPath.section];

  CGFloat collectionViewWidth = self.collectionView.bounds.size.width;
  CGFloat smallerItemWidth = 40;
  CGFloat largeritemWidth = collectionViewWidth - (smallerItemWidth * (itemsForSection.count - 1));

  CGFloat width = (indexPath.row == 0) ? largeritemWidth : smallerItemWidth;

  return CGSizeMake(width, kCellRowHeight);
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
  return self.scoreSummary.count;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
  NSArray *itemsInCurrentSection = self.scoreSummary[section];

  return itemsInCurrentSection.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
  SBScoreSummaryInfoCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kScoreSummaryinfoCell forIndexPath:indexPath];

  cell.section = indexPath.section;
  cell.row = indexPath.row;
  cell.game = self.game;

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