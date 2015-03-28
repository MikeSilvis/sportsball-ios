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
}

- (void)viewDidAppear:(BOOL)animated {
  [super viewDidAppear:animated];

  self.leagues = [SBUser currentUser].leagues;
}

- (void)setLeagues:(NSArray *)leagues {
  _leagues = leagues;

  [self.collectionView reloadData];
}

#pragma mark - Collection View

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
  return [self.leagues count];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
  SBStandingsViewCell *cell = [self.collectionView dequeueReusableCellWithReuseIdentifier:kStandingsViewCell forIndexPath:indexPath];
  cell.league = self.leagues[indexPath.row];

  NSArray *colors = @[
                      [UIColor redColor],
                      [UIColor purpleColor],
                      [UIColor greenColor],
                      [UIColor yellowColor]
                      ];
  cell.backgroundColor = colors[indexPath.row];

  return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
  return CGSizeMake(self.collectionView.bounds.size.width, self.collectionView.bounds.size.height);
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
