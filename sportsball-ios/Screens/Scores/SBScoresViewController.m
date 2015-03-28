//
//  SBScoresViewController.m
//  sportsball-ios
//
//  Created by Mike Silvis on 3/27/15.
//  Copyright (c) 2015 Mike Silvis. All rights reserved.
//

#import "SBScoresViewController.h"
#import "SBScoreIndexViewCell.h"
#import "SBUser.h"

@interface SBScoresViewController ()

@end

@implementation SBScoresViewController

static NSString * const kPagingSegue = @"pagingSegue";
static NSString * const kScoreIndexViewCell = @"scoreIndexViewCell";

- (void)defineCells:(UICollectionView *)collectionView {
  [collectionView registerNib:[UINib nibWithNibName:@"SBScoreIndexViewCell" bundle:nil]
        forCellWithReuseIdentifier:kScoreIndexViewCell];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
  SBScoreIndexViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kScoreIndexViewCell forIndexPath:indexPath];
  cell.league = [SBUser currentUser].leagues[indexPath.row];
  NSLog(@"adding league: %@ for: %ld", cell.league.name, (long)indexPath.row );

  return cell;
}

- (void)cellDidAppear:(UICollectionViewCell *)cell {
  [((SBScoreIndexViewCell *)cell) startTimer];
}

- (void)cellDidDisappear:(UICollectionViewCell *)cell {
  [((SBScoreIndexViewCell *)cell) cancelTimer];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
  if ([segue.identifier isEqualToString:kPagingSegue]) {
    SBPagingViewController *destinationViewController = segue.destinationViewController;
    destinationViewController.delegate = self;
  }
}

@end
