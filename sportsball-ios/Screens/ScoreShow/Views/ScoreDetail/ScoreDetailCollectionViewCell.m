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
static int const cellRowHeaderHeight = 20;
static NSString * const scoreDetailInfoCell = @"scoreDetailInfoCollectionViewCell";
static NSString * const scoreDetailHeaderCell = @"scoreDetailHeaderCollectionViewCell";

-(void)awakeFromNib {
  [super awakeFromNib];

  self.backgroundColor = [UIColor clearColor];
  self.collectionView.backgroundColor = [UIColor clearColor];

  [self.collectionView registerNib:[UINib nibWithNibName:@"ScoreDetailHeaderCollectionViewCell" bundle:nil]
        forSupplementaryViewOfKind:UICollectionElementKindSectionHeader
               withReuseIdentifier:scoreDetailHeaderCell];
  [self.collectionView registerNib:[UINib nibWithNibName:@"ScoreDetailInfoCollectionViewCell" bundle:nil]
        forCellWithReuseIdentifier:scoreDetailInfoCell];
}

+(CGSize)measureCellSizeWithResource:(NSArray *)resource andWidth:(CGFloat)width {
  CGFloat height = 0;

  for (ScoreDetail *scoreDetail in resource) {
    // Header Size
    height = height + cellRowHeaderHeight;

    // Row size
    height = height + (cellRowHeight * [scoreDetail.contentInfo count]);
  }

  return CGSizeMake(width, height);
}

-(void)setScoreDetails:(NSArray *)scoreDetails {
  _scoreDetails = scoreDetails;

  [self.collectionView reloadData];
}

#pragma mark - UICollectionView

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
  return CGSizeMake(self.collectionView.bounds.size.width, cellRowHeight);
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section {
  return CGSizeMake(self.collectionView.bounds.size.width, cellRowHeaderHeight);
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
  return self.scoreDetails.count;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
  ScoreDetail *scoreDetail = self.scoreDetails[section];

  return scoreDetail.contentInfo.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
  ScoreDetailInfoCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:scoreDetailInfoCell forIndexPath:indexPath];

  ScoreDetail *scoreDetail = self.scoreDetails[indexPath.section];
  cell.game = self.game;
  cell.contentInfo = scoreDetail.contentInfo[indexPath.row];

  return cell;
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
  if (kind == UICollectionElementKindSectionHeader) {
    ScoreDetailHeaderCollectionViewCell *cell = [collectionView dequeueReusableSupplementaryViewOfKind:kind
                                                                                   withReuseIdentifier:scoreDetailHeaderCell
                                                                                          forIndexPath:indexPath];
    ScoreDetail *scoreDetail = self.scoreDetails[indexPath.section];
    cell.label.text = scoreDetail.headerInfo;

    return cell;
  }

  return nil;
}

@end
