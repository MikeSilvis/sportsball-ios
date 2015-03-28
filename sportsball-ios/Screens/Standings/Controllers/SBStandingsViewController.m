//
//  SBStandingsViewController.m
//  sportsball-ios
//
//  Created by Mike Silvis on 3/28/15.
//  Copyright (c) 2015 Mike Silvis. All rights reserved.
//

#import "SBStandingsViewController.h"
#import "SBUser.h"
#import "SBStandingsViewCell.h"

@interface SBStandingsViewController ()

@property (nonatomic, strong) NSArray *leagues;

@end

@implementation SBStandingsViewController

static NSString * const kStandingsViewCell = @"standingsViewCell";

- (void)viewDidLoad {
    [super viewDidLoad];

  // Cells
  [self.collectionView registerNib:[UINib nibWithNibName:@"SBStandingsViewCell" bundle:nil]
        forCellWithReuseIdentifier:kStandingsViewCell];

  self.collectionView.backgroundColor = [UIColor clearColor];
  self.collectionView.showsHorizontalScrollIndicator = NO;
}

- (void)viewDidAppear:(BOOL)animated {
  [super viewDidAppear:animated];

  self.leagues = [SBUser currentUser].leagues;

}

- (void)setLeagues:(NSArray *)leagues {
  _leagues = leagues;

  self.pageControl.numberOfPages = [self.leagues count];
  self.pageControl.currentPage = [[SBUser currentUser].lastOpenedLeagueIndex intValue];
  [self.collectionView reloadData];
}

- (void)viewDidLayoutSubviews {
  [super viewDidLayoutSubviews];

  if (self.pageControl.currentPage > 0) {
    [self.collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:self.pageControl.currentPage inSection:0]
                                atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally
                                        animated:NO];
  }
}

#pragma mark - Collection View

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
  return [self.leagues count];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
  SBStandingsViewCell *cell = [self.collectionView dequeueReusableCellWithReuseIdentifier:kStandingsViewCell forIndexPath:indexPath];
  cell.league = self.leagues[indexPath.row];

  return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
  return self.collectionView.frame.size;
}

- (UIEdgeInsets)collectionView:(UICollectionView*)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
  return UIEdgeInsetsMake(0, 0, 0, 0);
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
  self.pageControl.currentPage = scrollView.contentOffset.x / self.collectionView.frame.size.width;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
  return 0;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
  return 0;
}

@end
