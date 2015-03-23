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
#import <Pusher.h>

@interface SBScoreIndexView () <PTPusherDelegate>

@property (nonatomic, strong) NSDate *currentDate;
@property (nonatomic, strong) PTPusher *client;
@property (nonatomic, weak) PTPusherChannel *channel;
@property bool isActive;

@end

@implementation SBScoreIndexView

static NSString * const kGameViewCell = @"GameViewCell";
static NSString * const kHeaderViewCell = @"HeaderViewCell";
static NSString * const kHeaderDatePickerViewCell = @"HeaderDatePickerViewCell";
static CGFloat const kHeaderSize = 74;
static CGFloat const kDatePickerSize = 50;

- (void)awakeFromNib {
  self.games = [NSMutableArray array];

  self.backgroundColor = [UIColor clearColor];
  self.collectionView.backgroundColor = [UIColor clearColor];

  // Cells
  [self.collectionView registerNib:[UINib nibWithNibName:@"SBGameCollectionViewCell" bundle:nil]
        forCellWithReuseIdentifier:kGameViewCell];
  // Headers
  [self.collectionView registerNib:[UINib nibWithNibName:@"SBLeagueHeader" bundle:nil]
        forSupplementaryViewOfKind:CSStickyHeaderParallaxHeader
               withReuseIdentifier:kHeaderViewCell];
  [self.collectionView registerNib:[UINib nibWithNibName:@"SBDatePickerCollectionViewCell" bundle:nil]
        forSupplementaryViewOfKind:UICollectionElementKindSectionHeader
               withReuseIdentifier:kHeaderDatePickerViewCell];

  CSStickyHeaderFlowLayout *layout = (id)self.collectionView.collectionViewLayout;
  if ([layout isKindOfClass:[CSStickyHeaderFlowLayout class]]) {
      layout.parallaxHeaderAlwaysOnTop = YES;
  }

  self.collectionView.indicatorStyle = UIScrollViewIndicatorStyleWhite;
  self.collectionView.scrollIndicatorInsets = UIEdgeInsetsMake(kHeaderSize + kDatePickerSize, 0, 0, 0);
  self.isActive = NO;

  [self setUpPusher];
}

- (void)updateSelectedDate:(NSDate *)selectedDate {
  self.currentDate = selectedDate;
}

- (void)setCurrentDate:(NSDate *)currentDate {
  NSDate *previouslySelectedDate = self.currentDate;
  _currentDate = currentDate;

  if (!self.isActive) {
    return;
  }

  if (![previouslySelectedDate isEqualToDate:currentDate]) {
    dispatch_async(dispatch_get_main_queue(), ^{
      self.games = @[];
      [self cancelTimer];
      [self startTimer];
    });
  }
}

- (void)cancelTimer {
  [self.client disconnect];
  self.isActive = NO;
  [self.channel unsubscribe];
}

- (void)startTimer {
  if (!self.isActive) {
    self.isActive = YES;
    [self.client connect];
    [self connectToChannel];
    [self findGames];
  }
}

- (void)setUpPusher {
  NSString *plistPath = [[NSBundle mainBundle] pathForResource:@"secretKeys" ofType:@"plist"];
  NSDictionary *keys = [NSDictionary dictionaryWithContentsOfFile:plistPath];

  self.client = [PTPusher pusherWithKey:[keys objectForKey:@"PUSHER_KEY"] delegate:self encrypted:YES];
  self.client.reconnectDelay = 3.0;
}

- (void)connectToChannel {
  if (!self.currentDate) {
    return;
  }

  NSString *channelName = [NSString stringWithFormat:@"scores_%@_%@", self.league.name, [self channelCurrentDateString]];
  self.channel = [self.client subscribeToChannelNamed:channelName];

  [self.channel bindToEventNamed:@"event" handleWithBlock:^(PTPusherEvent *channelEvent) {
    self.games = [self.league parseJSONScores:channelEvent.data];
  }];
}

- (NSString *)channelCurrentDateString {
  NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
  [formatter setDateFormat:@"yyyy-MM-dd"];

  return [formatter stringFromDate:self.currentDate];
}

- (void)findGames {
  if (!self.currentDate) {
    return;
  }

  if (self.games.count == 0) {
    self.activityIndicator.hidden = NO;
  }

  [self.league allScoresForDate:self.currentDate parameters:nil success:^(NSArray *games) {
    self.games = games;

    if (self.games.count == 0) {
      self.activityIndicator.hidden = YES;
    }
  } failure:^(NSError *error) {
    [self.delegate requestFailed:error];
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

  [self showFavoriteNotification];

  [self.collectionView reloadData];
}

- (void)showFavoriteNotification {
  for (SBGame *game in self.games) {
    if ([game.awayTeam favoriteScore] == [game.homeTeam favoriteScore]) {
      continue;
    }

    if ([game.homeTeam isFavorableTeam]) {
      [self.delegate askForFavoriteTeam:game.homeTeam];
      return;
    }
    else if ([game.awayTeam isFavorableTeam]) {
      [self.delegate askForFavoriteTeam:game.awayTeam];
      return;
    }
  }
}

- (void)layoutSubviews {
  [super layoutSubviews];

  CSStickyHeaderFlowLayout *layout = (id)self.collectionView.collectionViewLayout;
  layout.parallaxHeaderReferenceSize = CGSizeMake(self.bounds.size.width, kHeaderSize);
  layout.parallaxHeaderMinimumReferenceSize = CGSizeMake(self.bounds.size.width, kHeaderSize);
  layout.itemSize = CGSizeMake(self.frame.size.width, layout.itemSize.height);
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

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section {
  return CGSizeMake(self.bounds.size.width, kDatePickerSize);
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
  self.activityIndicator.hidden = YES;

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

    return cell;
  }
  else if ([kind isEqualToString:UICollectionElementKindSectionHeader]) {
    SBDatePickerCollectionViewCell *cell = [collectionView dequeueReusableSupplementaryViewOfKind:kind
                                                                              withReuseIdentifier:kHeaderDatePickerViewCell
                                                                                     forIndexPath:indexPath];
    cell.delegate = self;
    cell.dates = self.league.schedule;
    if (!self.currentDate) {
      [cell.datePicker selectDateClosestToToday];
    }
    else {
      [cell.datePicker selectDate:self.currentDate];
    }

    return cell;
  }

  return nil;
}

@end
