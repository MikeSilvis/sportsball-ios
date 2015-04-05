//
//  ScoreIndexView.m
//  sportsball-ios
//
//  Created by Mike Silvis on 11/6/14.
//  Copyright (c) 2014 Mike Silvis. All rights reserved.
//

#import "SBScoreIndexViewCell.h"
#import "SBGameCollectionViewCell.h"
#import "CSStickyHeaderFlowLayout.h"
#import "SBUser.h"
#import <Pusher.h>
#import "SBConstants.h"

@interface SBScoreIndexViewCell () <PTPusherDelegate>

@property (nonatomic, strong) NSDate *currentDate;
@property (nonatomic, strong) PTPusher *client;
@property (nonatomic, weak) PTPusherChannel *channel;
@property (nonatomic, strong) NSArray *games;
@property (nonatomic, strong) NSIndexPath *selectedIndexPath;
@property (nonatomic, strong) SBGame *selectedGame;

@end

@implementation SBScoreIndexViewCell

static NSString * const kGameViewCell = @"GameViewCell";
static NSString * const kHeaderViewCell = @"HeaderViewCell";
static NSString * const kHeaderDatePickerViewCell = @"HeaderDatePickerViewCell";
static CGFloat const kHeaderSize = 100;
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
}

- (void)setLeague:(SBLeague *)league {
  _league = league;

  [self.collectionView reloadData];
}

- (void)updateSelectedDate:(NSDate *)selectedDate {
  self.currentDate = selectedDate;
}

- (void)setCurrentDate:(NSDate *)currentDate {
  NSDate *previouslySelectedDate = self.currentDate;
  _currentDate = currentDate;

  if (![previouslySelectedDate isEqualToDate:currentDate]) {
    dispatch_async(dispatch_get_main_queue(), ^{
      _games = @[];
      self.games = @[];
      [self cancelTimer];
      [self startTimer];
    });
  }
}

#pragma mark - Real Time

- (void)cancelTimer {
  [self.channel unsubscribe];
  [self.client disconnect];
}

- (void)startTimer {
  [self setUpPusher];
  [self connectToChannel];
  [self findGames];
}

- (void)setUpPusher {
  self.client = [PTPusher pusherWithKey:[[SBConstants sharedInstance] getSecretValueFrom:@"PUSHER_KEY"] delegate:self encrypted:YES];
  self.client.reconnectDelay = 3.0;
  [self.client connect];
}

- (void)connectToChannel {
  if (!self.currentDate) {
    return;
  }

  if (![[self dateWithoutTime:self.currentDate] isEqualToDate:[self dateWithoutTime:[NSDate date]]]) {
    return;
  }

  NSString *channnelName = [NSString stringWithFormat:@"scores_%@", self.league.name];
  self.channel = [self.client subscribeToChannelNamed:channnelName];

  [self.channel bindToEventNamed:@"event" handleWithBlock:^(PTPusherEvent *channelEvent) {
    self.games = [self.league parseJSONScores:channelEvent.data];
  }];
}

- (NSDate *)dateWithoutTime:(NSDate *)date {
  unsigned int flags = NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay;
  NSCalendar *calendar = [NSCalendar currentCalendar];
  NSDateComponents *components = [calendar components:flags fromDate:date];

  return [calendar dateFromComponents:components];
}

#pragma mark - Finding Games

- (void)findGames {
  if (!self.currentDate) {
    return;
  }

  if (!self.games.count == 0) {
    return;
  }

  self.activityIndicator.hidden = NO;

  [self.league allScoresForDate:self.currentDate parameters:nil success:^(NSArray *games) {
    self.games = games;
    self.activityIndicator.hidden = YES;
  } failure:^(NSError *error) {
//    [self.delegate requestFailed:error];
    self.activityIndicator.hidden = YES;
  }];
}

- (void)setGames:(NSArray *)games {
  NSMutableArray *tempGames = [NSMutableArray arrayWithArray:games];
  NSArray *sortedGames = [NSArray array];

  sortedGames = [tempGames sortedArrayUsingComparator:^NSComparisonResult(SBGame *game1, SBGame *game2) {
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

  NSInteger updatedSelectedItemPath = -1;
  SBGame *updatedGame = nil;

  if (self.selectedGame) {
    for (int i = 0; i < sortedGames.count; i++) {
      SBGame *game = sortedGames[i];

      if ([game.awayTeam.name isEqualToString:self.selectedGame.awayTeam.name]) {
        updatedSelectedItemPath = i;
        updatedGame = game;
        break;
      }
    }
  }

  if (([self.games count] == 0) || (!self.selectedGame)) {
    _games = sortedGames;
  }

  [self showFavoriteNotification];

  [self.collectionView reloadData];

  if ((self.selectedIndexPath) && (self.selectedIndexPath.row != updatedSelectedItemPath)) {
    [self performSelector:@selector(updateGameLocationWithAnimation:)
               withObject:@[
                            self.selectedIndexPath,
                            [NSIndexPath indexPathForRow:updatedSelectedItemPath inSection:0]
                           ]
               afterDelay:0.5];
  }
}

- (void)updateGameLocationWithAnimation:(NSArray *)paths {
  dispatch_async(dispatch_get_main_queue(), ^{
    if ([self.games count] > 0) {
      [self.collectionView moveItemAtIndexPath:[paths firstObject] toIndexPath:[paths lastObject]];
    }

    self.selectedIndexPath = nil;
    self.selectedGame = nil;

    // Erase current games and reorder them
    NSArray *currentGames = self.games;
    _games = nil;
    self.games = currentGames;
  });
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

#pragma mark - Collection View Methods

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
  self.selectedGame = self.games[indexPath.row];

  [self.delegate selectedGame:self.selectedGame];
  self.selectedIndexPath = indexPath;
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
    if (self.currentDate && [self.league.schedule containsObject:self.currentDate]) {
      [cell.datePicker selectDate:self.currentDate];
    }
    else {
      [cell.datePicker selectDateClosestToToday];
    }

    return cell;
  }

  return nil;
}

@end
