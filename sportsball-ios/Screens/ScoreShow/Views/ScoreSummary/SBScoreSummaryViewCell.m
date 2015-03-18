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
static int const kCellRowHeight = 25;
static int const kCellPadding = 30;
static int const kMinTeamNameSize = 130;

- (void)awakeFromNib {
  [super awakeFromNib];

  self.backgroundColor = [UIColor clearColor];
  self.collectionView.backgroundColor = [UIColor clearColor];
  self.selectionStyle = UITableViewCellSelectionStyleNone;

  [self.collectionView registerNib:[UINib nibWithNibName:@"ScoreSummaryInfoViewCell" bundle:nil] forCellWithReuseIdentifier:kScoreSummaryinfoCell];
  self.collectionView.indicatorStyle = UIScrollViewIndicatorStyleWhite;
}

+ (CGSize)measureCellSizeWithResource:(NSArray *)resource andWidth:(CGFloat)width {
  CGFloat cellHeight = ([((NSArray *)[resource firstObject]) count] * kCellRowHeight);

  return CGSizeMake(width, cellHeight + kCellPadding);
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

- (int)minTeamSize {
  int screenHeightFloat = (int)[[UIScreen mainScreen] bounds].size.height;
  NSString *screenHeightString = [NSString stringWithFormat:@"%i", screenHeightFloat];

  NSDictionary *teamSizes = @{
                              @"667" : @138, // iPhone 6
                              @"736" : @130, // iPhone 6+
                              @"568" : @125, // iPhone 5
                              @"480" : @125 // iPhone 4
                              };

  if (teamSizes[screenHeightString]) {
    return [teamSizes[screenHeightString] intValue];
  }
  else {
    return kMinTeamNameSize;
  }
}

#pragma mark - UICollectionView

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
  NSArray *itemsForSection = self.scoreSummary;

  CGFloat collectionViewWidth = self.collectionView.bounds.size.width;
  CGFloat smallerItemWidth = 40;
  CGFloat largeritemWidth = collectionViewWidth - (smallerItemWidth * (itemsForSection.count -1));

  if (largeritemWidth < [self minTeamSize]) {
    largeritemWidth = [self minTeamSize];
  }

  CGFloat width = (indexPath.section == 0) ? largeritemWidth : smallerItemWidth;

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

  cell.indexPath = indexPath;
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