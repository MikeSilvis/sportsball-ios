//
//  ScoreSummaryCollectionViewCell.m
//  sportsball-ios
//
//  Created by Mike Silvis on 12/4/14.
//  Copyright (c) 2014 Mike Silvis. All rights reserved.
//

#import "ScoreSummaryCollectionViewCell.h"
#import "ScoreSummaryInfoCollectionViewCell.h"
#import "ScoreDetailHeaderCollectionViewCell.h"
#import "Team.h"

@implementation ScoreSummaryCollectionViewCell

static NSString * const scoreSummaryinfoCell = @"scoreSummaryinfoCell";
static int const cellRowHeight = 30;
static int const cellPaddingHeight = 10;

-(void)awakeFromNib {
  [super awakeFromNib];

  self.backgroundColor = [UIColor clearColor];
  self.collectionView.backgroundColor = [UIColor clearColor];
  self.selectionStyle = UITableViewCellSelectionStyleNone;

  [self.collectionView registerNib:[UINib nibWithNibName:@"ScoreSummaryInfoViewCell" bundle:nil] forCellWithReuseIdentifier:scoreSummaryinfoCell];
}

+(CGSize)measureCellSizeWithResource:(NSArray *)resource andWidth:(CGFloat)width {
  return CGSizeMake(width, (resource.count * cellRowHeight) + cellPaddingHeight);
}

-(void)setGame:(Game *)game {
  _game = game;

  self.scoreSummary = game.boxscore.scoreSummary;
}

-(void)setScoreSummary:(NSArray *)scoreSummary {
  _scoreSummary = scoreSummary;

  [self.collectionView reloadData];
}

#pragma mark - UICollectionView

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
  NSArray *itemsForSection = self.scoreSummary[indexPath.section];

  CGFloat largeritemWidth = self.collectionView.bounds.size.width * 0.3;
  CGFloat smallerItemWidth = (self.collectionView.bounds.size.width - largeritemWidth) / (itemsForSection.count - 1);
  CGFloat width = (indexPath.row == 0) ? largeritemWidth : smallerItemWidth;

  return CGSizeMake(width, cellRowHeight);
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

  cell.section = indexPath.section;
  cell.row = indexPath.row;
  cell.game = self.game;

  return cell;
}

@end