//
//  ScoreSummaryCollectionViewCell.m
//  sportsball-ios
//
//  Created by Mike Silvis on 12/4/14.
//  Copyright (c) 2014 Mike Silvis. All rights reserved.
//

#import "ScoreSummaryCollectionViewCell.h"
#import "ScoreSummaryInfoCollectionViewCell.h"

@implementation ScoreSummaryCollectionViewCell

static NSString * const scoreSummaryinfoCell = @"scoreSummaryinfoCell";
static int const cellRowHeight = 30;

-(void)awakeFromNib {
  [self.collectionView registerNib:[UINib nibWithNibName:@"ScoreSummaryInfoViewCell" bundle:nil] forCellWithReuseIdentifier:scoreSummaryinfoCell];
}

+(CGSize)measureCellSizeWithResource:(NSArray *)resource andWidth:(CGFloat)width {
  return CGSizeMake(width, resource.count * cellRowHeight);
}

-(void)setScoreSummary:(NSArray *)scoreSummary {
  _scoreSummary = scoreSummary;

  [self.collectionView reloadData];
}

-(void)layoutSubviews {
  [super layoutSubviews];

  self.collectionView.frame = self.bounds;
}

#pragma mark - UICollectionView

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
  NSArray *itemsForSection = self.scoreSummary[indexPath.section];

  return CGSizeMake((self.bounds.size.width / itemsForSection.count), cellRowHeight);
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
  return self.scoreSummary.count;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
  NSArray *itemsInCurrentSection = self.scoreSummary[section];

  return itemsInCurrentSection.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
  ScoreSummaryInfoCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:scoreSummaryinfoCell forIndexPath:indexPath];
  cell.score.text = self.scoreSummary[indexPath.section][indexPath.row];

  return cell;
}

@end