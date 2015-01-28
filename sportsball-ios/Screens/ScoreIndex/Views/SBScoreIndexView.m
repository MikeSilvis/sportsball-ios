//
//  ScoreIndexView.m
//  sportsball-ios
//
//  Created by Mike Silvis on 11/6/14.
//  Copyright (c) 2014 Mike Silvis. All rights reserved.
//

#import "SBScoreIndexView.h"
#import "SBGameCollectionViewCell.h"
#import "CSStickyHeaderFlowLayout.h"
#import "SBUser.h"

@implementation SBScoreIndexView

static NSString * const kGameViewCell = @"GameViewCell";
static NSString * const kHeaderViewCell = @"HeaderViewCell";
static CGFloat const kHeaderSize = 74;

- (void)awakeFromNib {
  self.games = [NSMutableArray array];

  self.backgroundColor = [UIColor clearColor];
  self.collectionView.backgroundColor = [UIColor clearColor];

  [self.collectionView registerNib:[UINib nibWithNibName:@"SBGameCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:kGameViewCell];
  [self.collectionView registerNib:[UINib nibWithNibName:@"SBLeagueHeader" bundle:nil] forSupplementaryViewOfKind:CSStickyHeaderParallaxHeader withReuseIdentifier:kHeaderViewCell];

  CSStickyHeaderFlowLayout *layout = (id)self.collectionView.collectionViewLayout;
  if ([layout isKindOfClass:[CSStickyHeaderFlowLayout class]]) {
      layout.parallaxHeaderAlwaysOnTop = YES;
      layout.disableStickyHeaders = YES;
  }

  self.collectionView.indicatorStyle = UIScrollViewIndicatorStyleWhite;
  self.collectionView.scrollIndicatorInsets = UIEdgeInsetsMake(kHeaderSize, 0, 0, 0);

  self.currentDate = [NSDate date];
  self.activityIndicator.hidden = YES;
}

- (void)setUpDatePicker {
  self.datePicker.dates = self.league.schedule;
  [self.datePicker selectDateClosestToToday];
  self.currentDate = self.datePicker.selectedDate;

  [self.datePicker addTarget:self action:@selector(updateSelectedDate) forControlEvents:UIControlEventValueChanged];
}

- (void)setLeague:(SBLeague *)league {
  _league = league;

  [self setUpDatePicker];
}

- (void)updateSelectedDate {
  self.currentDate = self.datePicker.selectedDate;

  self.games = @[];
  [self cancelTimer];
  [self startTimer];
}

- (void)cancelTimer {
  [self.scorePuller invalidate];
  self.scorePuller = nil;
}

- (void)startTimer {
  if (!self.scorePuller) {
    [self findGames];
    self.scorePuller = [NSTimer scheduledTimerWithTimeInterval:90 target:self selector:@selector(findGames) userInfo:nil repeats:YES];
  }
}

- (void)findGames {
  if (self.games.count == 0) {
    self.activityIndicator.hidden = NO;
  }

  [self.league allScoresForDate:self.currentDate parameters:nil success:^(NSArray *games) {
    self.games = games;
    self.activityIndicator.hidden = YES;
  } failure:^(NSError *error) {
    [self.delegate requestFailed:[[SBUser currentUser] networkConnectionErrorMessage:error]];
    self.activityIndicator.hidden = YES;
  }];
}

- (void)setGames:(NSArray *)games {
  NSMutableArray *tempGames = [NSMutableArray arrayWithArray:games];

  games = [tempGames sortedArrayUsingComparator:^NSComparisonResult(SBGame *game1, SBGame *game2) {
    int game1Score = [game1 favoriteScore];
    int game2Score = [game2 favoriteScore];

    if (game1Score > game2Score) {
      return (NSComparisonResult)NSOrderedAscending;
    }
    else if (game1Score < game2Score) {
      return (NSComparisonResult)NSOrderedDescending;
    }
    else {
      return (NSComparisonResult)NSOrderedSame;
    }
  }];


  _games = games;

  [self.collectionView reloadData];
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
  SBGame *selectedGame = self.games[indexPath.row];

  [self.delegate selectedGame:selectedGame];
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
  return self.games.count;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
  return CGSizeMake(self.bounds.size.width, 60);
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
  SBGame *currentGame = self.games[indexPath.row];
  SBGameCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kGameViewCell forIndexPath:indexPath];
  cell.currentGame = currentGame;

  return cell;
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
  if ([kind isEqualToString:CSStickyHeaderParallaxHeader]) {
    SBLeagueHeader *cell = [collectionView dequeueReusableSupplementaryViewOfKind:kind
                                                                        withReuseIdentifier:kHeaderViewCell
                                                                               forIndexPath:indexPath];
    cell.currentLeague = self.league;
    cell.delegate = self;

    return cell;
  }

  return nil;
}

- (void)logoClicked {
  [self.delegate requestClose];
}

- (void)layoutSubviews {
  [super layoutSubviews];

  CSStickyHeaderFlowLayout *layout = (id)self.collectionView.collectionViewLayout;
  layout.parallaxHeaderReferenceSize = CGSizeMake(self.bounds.size.width, kHeaderSize);
  layout.parallaxHeaderMinimumReferenceSize = CGSizeMake(self.bounds.size.width, kHeaderSize);
  layout.itemSize = CGSizeMake(self.frame.size.width, layout.itemSize.height);
}

@end
