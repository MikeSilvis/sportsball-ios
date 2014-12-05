//
//  ScoreDetailCollectionViewCell.m
//  sportsball-ios
//
//  Created by Mike Silvis on 12/4/14.
//  Copyright (c) 2014 Mike Silvis. All rights reserved.
//

#import "ScoreDetailCollectionViewCell.h"
#import "ScoreDetailInfoCollectionViewCell.h"

@implementation ScoreDetailCollectionViewCell

static int const cellRowHeight = 30;
static NSString * const scoreDetailInfoCell = @"scoreDetailInfoCollectionViewCell";

-(void)awakeFromNib {
  [self.collectionView registerNib:[UINib nibWithNibName:@"ScoreDetailInfoCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:scoreDetailInfoCell];
}

+(CGSize)measureCellSizeWithResource:(NSArray *)resource andWidth:(CGFloat)width {
  return CGSizeMake(width, 200);
}

-(void)setScoreDetail:(NSArray *)scoreDetail {
  _scoreDetail = scoreDetail;

  [self.collectionView reloadData];
}

-(void)layoutSubviews {
  [super layoutSubviews];

  self.collectionView.frame = self.bounds;
}

#pragma mark - UICollectionView

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
  return CGSizeMake(self.bounds.size.width, cellRowHeight);
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
  return self.scoreDetail.count;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
  return 5;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
  ScoreDetailInfoCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:scoreDetailInfoCell forIndexPath:indexPath];
  NSLog(@"looping");

  return cell;
}

@end
