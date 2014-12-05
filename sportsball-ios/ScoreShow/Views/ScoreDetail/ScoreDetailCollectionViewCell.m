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
static NSString * const scoreDetailHeaderCell = @"scoreDetailHeaderCollectionViewCell";

-(void)awakeFromNib {
  [self.collectionView registerNib:[UINib nibWithNibName:@"ScoreDetailInfoCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:scoreDetailInfoCell];
  [self.collectionView registerNib:[UINib nibWithNibName:@"ScoreDetailHeaderCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:scoreDetailHeaderCell];
}

+(CGSize)measureCellSizeWithResource:(NSArray *)resource andWidth:(CGFloat)width {
  return CGSizeMake(width, 200);
}

-(void)setScoreDetails:(NSArray *)scoreDetail {
  _scoreDetails = scoreDetail;

  [self.collectionView reloadData];
}

-(void)layoutSubviews {
  [super layoutSubviews];

  self.collectionView.frame = self.bounds;
}

#pragma mark - UICollectionView

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
  ScoreDetail *scoreDetail = self.scoreDetails[indexPath.section];

  CGFloat widthOfContent = self.bounds.size.width * 0.7;
  CGFloat widthOfEverything = (self.bounds.size.width - widthOfContent) / (scoreDetail.contentInfo.count - 1);

  CGFloat width;
  if (indexPath.row == 2) {
    width = widthOfContent;
  }
  else {
    width = widthOfEverything;
  }

  return CGSizeMake(width, cellRowHeight);
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section {
  return CGSizeMake(self.bounds.size.width, cellRowHeight);
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
  cell.label.text = scoreDetail.contentInfo[indexPath.row];

  return cell;
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
  if (kind == UICollectionElementKindSectionHeader) {
    ScoreDetailHeaderCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:scoreDetailHeaderCell forIndexPath:indexPath];

    ScoreDetail *scoreDetail = self.scoreDetails[indexPath.section];
    cell.label.text = scoreDetail.headerInfo;

    return cell;
  }

  return nil;
}

@end
