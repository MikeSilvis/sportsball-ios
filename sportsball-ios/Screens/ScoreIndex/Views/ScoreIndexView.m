//
//  ScoreIndexView.m
//  sportsball-ios
//
//  Created by Mike Silvis on 11/6/14.
//  Copyright (c) 2014 Mike Silvis. All rights reserved.
//

#import "ScoreIndexView.h"
#import "GameCollectionViewCell.h"
#import "LeagueHeader.h"
#import "CSStickyHeaderFlowLayout.h"
#import "UIImage+Blur.h"
#import "NSDate+SBDateWithYear.h"
#import "UIImage+FontAwesome.h"

@implementation ScoreIndexView

static NSString * const gameViewCell = @"gameViewCell";
static NSString * const headerViewCell = @"headerViewCell";
static CGFloat const headerSize = 74;

-(void)awakeFromNib {
  self.games = [NSMutableArray array];

  self.backgroundColor = [UIColor clearColor];
  self.collectionView.backgroundColor = [UIColor clearColor];

  [self.collectionView registerNib:[UINib nibWithNibName:@"GameCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:gameViewCell];
  [self.collectionView registerNib:[UINib nibWithNibName:@"LeagueHeader" bundle:nil] forSupplementaryViewOfKind:CSStickyHeaderParallaxHeader withReuseIdentifier:headerViewCell];

  CSStickyHeaderFlowLayout *layout = (id)self.collectionView.collectionViewLayout;
  if ([layout isKindOfClass:[CSStickyHeaderFlowLayout class]]) {
      layout.parallaxHeaderAlwaysOnTop = YES;
      layout.disableStickyHeaders = YES;
  }

  self.collectionView.indicatorStyle = UIScrollViewIndicatorStyleWhite;
  self.collectionView.scrollIndicatorInsets = UIEdgeInsetsMake(headerSize, 0, 0, 0);

  self.currentDate = [NSDate date];
}

-(void)setUpDatePicker {
  self.datePicker.dates = self.league.schedule;
//  [self.datePicker selectDateClosestToToday];
  [self.datePicker selectDate:[NSDate dateWithYear:2015 month:1 day:4]];
  self.currentDate = self.datePicker.selectedDate;

  [self.datePicker addTarget:self action:@selector(updateSelectedDate) forControlEvents:UIControlEventValueChanged];
}

-(void)setLeague:(League *)league {
  _league = league;

  [self setUpDatePicker];
}

- (void)updateSelectedDate {
  self.currentDate = self.datePicker.selectedDate;

  self.games = @[];
  [self cancelTimer];
  [self startTimer];
}

-(void)cancelTimer {
  [self.scorePuller invalidate];
  self.scorePuller = nil;
}

-(void)startTimer {
  if (!self.scorePuller) {
    [self findGames];
    self.scorePuller = [NSTimer scheduledTimerWithTimeInterval:90 target:self selector:@selector(findGames) userInfo:nil repeats:YES];
  }
}

-(void)findGames {
  if (self.games.count == 0) {
    [self.delegate didStartLoading];
  }

  [self.league allScoresForDate:self.currentDate parameters:nil success:^(NSArray *games) {
    self.games = games;
    [self.collectionView reloadData];
    [self.delegate didEndLoading];
  } failure:^(NSError *error) {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle: @"Sorry :("
                                                    message: @"Something happened, and the data failed to load."
                                                   delegate: nil
                                          cancelButtonTitle:@"OK"
                                          otherButtonTitles:nil];
    if (self.games.count == 0) {
      [alert show];
    }
    [self.delegate didEndLoading];
  }];
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
  Game *selectedGame = self.games[indexPath.row];

  [self.delegate selectedGame:selectedGame];
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
  return self.games.count;
}

-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
  return CGSizeMake(self.bounds.size.width, 60);
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
  Game *currentGame = self.games[indexPath.row];
  GameCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:gameViewCell forIndexPath:indexPath];
  cell.currentGame = currentGame;


  return cell;
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
  if ([kind isEqualToString:CSStickyHeaderParallaxHeader]) {
    LeagueHeader *cell = [collectionView dequeueReusableSupplementaryViewOfKind:kind
                                                                        withReuseIdentifier:headerViewCell
                                                                               forIndexPath:indexPath];
    cell.currentLeague = self.league;

    return cell;
  }

  return nil;
}

-(void)layoutSubviews {
  [super layoutSubviews];

  CSStickyHeaderFlowLayout *layout = (id)self.collectionView.collectionViewLayout;
  layout.parallaxHeaderReferenceSize = CGSizeMake(self.bounds.size.width, headerSize);
  layout.parallaxHeaderMinimumReferenceSize = CGSizeMake(self.bounds.size.width, headerSize);
  layout.itemSize = CGSizeMake(self.frame.size.width, layout.itemSize.height);
}

@end
