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
#import "SBPagingViewController.h"

@interface SBStandingsViewController ()

@end

@implementation SBStandingsViewController

static NSString * const kPagingSegue = @"pagingSegue";
static NSString * const kStandingsViewCell = @"standingsViewCell";

- (void)defineCells:(UICollectionView *)collectionView {
  [collectionView registerNib:[UINib nibWithNibName:@"SBStandingsViewCell" bundle:nil]
        forCellWithReuseIdentifier:kStandingsViewCell];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
  SBStandingsViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kStandingsViewCell forIndexPath:indexPath];
  cell.league = [SBUser currentUser].leagues[indexPath.row];

  return cell;
}

- (void)cellDidAppear:(UICollectionViewCell *)cell {
  SBStandingsViewCell *standingsCell = (SBStandingsViewCell *)cell;
  [standingsCell startTimer];
//  [((SBStandingsViewCell *)cell) startTimer];
}

- (void)cellDidDisappear:(UICollectionViewCell *)cell {
  [((SBStandingsViewCell *)cell) cancelTimer];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
  if ([segue.identifier isEqualToString:kPagingSegue]) {
    SBPagingViewController *destinationViewController = segue.destinationViewController;
    destinationViewController.delegate = self;
  }
}


@end
