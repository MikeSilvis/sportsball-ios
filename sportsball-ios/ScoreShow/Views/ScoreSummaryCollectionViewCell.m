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

//-(void)awakeFromNib {
//  [self.collectionView registerNib:[UINib nibWithNibName:@"ScoreSummaryInfoViewCell" bundle:nil] forCellWithReuseIdentifier:scoreSummaryinfoCell];
//}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
//  return self.scoreSummary.count;
//  return 1;
  return 0;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
//  NSArray *itemsInCurrentSection = self.scoreSummary[section];

//  return itemsInCurrentSection.count;
  return 0;
}

-(void)setScoreSummary:(NSArray *)scoreSummary {
  _scoreSummary = scoreSummary;

  [self.collectionView reloadData];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
//  ScoreSummaryInfoCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:scoreSummaryinfoCell forIndexPath:indexPath];
  UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"rabble" forIndexPath:indexPath];
//  cell.score.text = @"1";

  return cell;
}

@end