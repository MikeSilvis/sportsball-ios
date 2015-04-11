//
//  SBScores2ViewController.m
//  sportsball-ios
//
//  Created by Mike Silvis on 3/31/15.
//  Copyright (c) 2015 Mike Silvis. All rights reserved.
//

#import "SBScoresViewController.h"
#import "SBLeagueHeader.h"
#import "SBGameCollectionViewCell.h"
#import "CSStickyHeaderFlowLayout.h"
#import "SBUser.h"
#import <Pusher.h>
#import <MPGNotification.h>
#import "EDColor.h"
#import "SBPreviewViewController.h"
#import "SBBoxscoreViewController.h"
#import "SBPagingViewController.h"
#import "SBConstants.h"

@interface SBScoresViewController () <UICollectionViewDataSource, UICollectionViewDelegate, SBModalDelegate, SBPagingViewDelegate>

@property (nonatomic, strong) NSDate *currentDate;
@property (nonatomic, weak) PTPusherChannel *channel;
@property (nonatomic, strong) NSArray *games;
@property (nonatomic, strong) NSIndexPath *selectedIndexPath;
@property (nonatomic, strong) SBGame *selectedGame;

@end

@implementation SBScoresViewController

static NSString * const kGameViewCell = @"GameViewCell";
static NSString * const kHeaderViewCell = @"HeaderViewCell";
static NSString * const kHeaderDatePickerViewCell = @"HeaderDatePickerViewCell";

static CGFloat const kDatePickerSize = 50;

static NSString *kPagingSegue = @"pagingSegue";
static NSString *kScoreShowSegue = @"scoreShowSegue";
static NSString *kScorePreviewSegue = @"kScorePreviewSegue";

- (void)viewDidLoad {
  [super viewDidLoad];

  self.games = [NSMutableArray array];

  self.view.backgroundColor = [UIColor clearColor];
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

- (void)viewDidAppear:(BOOL)animated {
  [super viewDidAppear:animated];
  
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

- (void)setLeague:(SBLeague *)league {
  _league = league;
  
  [self.collectionView reloadData];
}

- (void)dismissedModal {
  [self startTimer];
}

#pragma mark - Real Time

- (void)cancelTimer {
  [self.channel unsubscribe];
}

- (void)startTimer {
  [self connectToChannel];
  [self findGames];
}

- (void)connectToChannel {
  if (!self.currentDate) {
    return;
  }

  if (![[self dateWithoutTime:self.currentDate] isEqualToDate:[self dateWithoutTime:[NSDate date]]]) {
    return;
  }

  NSString *channnelName = [NSString stringWithFormat:@"scores_%@", self.league.name];
  self.channel = [[SBUser currentUser].client subscribeToChannelNamed:channnelName];

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
    [self showNetworkError:error];
    self.activityIndicator.hidden = YES;
  }];
}

- (void)showNetworkError:(NSError *)error {
  MPGNotification *notification = [MPGNotification notificationWithHostViewController:self
                                                                                title:[[SBUser currentUser] networkConnectionErrorMessage:nil]
                                                                             subtitle:nil
                                                                      backgroundColor:[UIColor colorWithRed:0.910 green:0.278 blue:0.128 alpha:1.000]
                                                                            iconImage:[[SBUser currentUser] networkConnectionErrorIcon]];
  notification.animationType = MPGNotificationAnimationTypeDrop;
  [notification show];
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
      [self askForFavoriteTeam:game.homeTeam];
      return;
    }
    else if ([game.awayTeam isFavorableTeam]) {
        [self askForFavoriteTeam:game.awayTeam];
        return;
    }
  }
}
#pragma mark - Favorite Notification

- (void)askForFavoriteTeam:(SBTeam *)team {
  if ([team parseObject][@"pushEnabled"] != nil) {
    return;
  }

  NSString *headerFavoriteTeamRequest = @"Favorite Team";
  NSString *subtitleFavoriteTeamRequest = [NSString stringWithFormat:@"Love the %@?", team.name];

  CGFloat iconSize = 32;
  FAKFontAwesome *boltIcon = [FAKFontAwesome boltIconWithSize:iconSize];
  UIImage *boltIconImage = [UIImage imageWithFontAwesomeIcon:boltIcon andSize:iconSize andColor:@"fff"];

  MPGNotification *notification = [MPGNotification notificationWithHostViewController:self
                                                                                title:headerFavoriteTeamRequest
                                                                             subtitle:subtitleFavoriteTeamRequest
                                                                      backgroundColor:[UIColor colorWithHexString:@"274385"]
                                                                            iconImage:boltIconImage];
  [notification setButtonConfiguration:MPGNotificationButtonConfigrationTwoButton withButtonTitles:@[@"Yes!", @"No"]];
  notification.animationType = MPGNotificationAnimationTypeDrop;
  notification.swipeToDismissEnabled = NO;
  notification.backgroundTapsEnabled = NO;

  [notification showWithButtonHandler:^(MPGNotification *notification, NSInteger buttonIndex) {
    if (buttonIndex == notification.firstButton.tag) {
      [self registerForPushWithFavoriteTeam:(SBTeam *)team];
    }
    else if (buttonIndex == notification.secondButton.tag) {
      [self registerNoPushForTeam:(SBTeam *)team];
    }
  }];
}

- (void)registerForPushWithFavoriteTeam:(SBTeam *)team {
  UIApplication *application = [UIApplication sharedApplication];

  UIUserNotificationType userNotificationTypes = (UIUserNotificationTypeAlert | UIUserNotificationTypeBadge | UIUserNotificationTypeSound);
  UIUserNotificationSettings *settings = [UIUserNotificationSettings settingsForTypes:userNotificationTypes
                                                                           categories:nil];
  [application registerUserNotificationSettings:settings];
  [application registerForRemoteNotifications];

  PFObject *object = [team parseObject];
  object[@"pushEnabled"] = @YES;
  [object saveEventually];
}

- (void)registerNoPushForTeam:(SBTeam *)team {
  PFObject *object = [team parseObject];
  object[@"pushEnabled"] = @NO;
  [object saveEventually];
}

- (void)viewWillLayoutSubviews {
  [super viewWillLayoutSubviews];
  
  CSStickyHeaderFlowLayout *layout = (id)self.collectionView.collectionViewLayout;
  layout.parallaxHeaderReferenceSize = CGSizeMake(self.view.bounds.size.width, kHeaderSize);
  layout.parallaxHeaderMinimumReferenceSize = CGSizeMake(self.view.bounds.size.width, kHeaderSize);
  layout.itemSize = CGSizeMake(self.view.frame.size.width, layout.itemSize.height);
}

#pragma mark - Collection View Methods

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
  self.selectedGame = self.games[indexPath.row];
  self.selectedIndexPath = indexPath;

  [[SBUser currentUser] appendFavoriteTeams:self.selectedGame.homeTeam andTeam:self.selectedGame.awayTeam andLeague:self.selectedGame.leagueName];

  if (self.selectedGame.isPregame) {
    [self performSegueWithIdentifier:kScorePreviewSegue sender:self];
  }
  else {
    [self performSegueWithIdentifier:kScoreShowSegue sender:self];
  }
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
  return self.games.count;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
  return CGSizeMake(self.view.bounds.size.width, 60);
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section {
  return CGSizeMake(self.view.bounds.size.width, kDatePickerSize);
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

- (UIViewController *)viewControllerAtIndex:(NSUInteger)index {
  SBScoresViewController *pageContentViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"SBScoresViewController"];
  pageContentViewController.pageIndex = index;
  pageContentViewController.parentRect = self.view.frame;
  pageContentViewController.league = [SBUser currentUser].leagues[index];

  return pageContentViewController;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
  if ([segue.identifier isEqualToString:kPagingSegue]) {
    SBPagingViewController *viewController = segue.destinationViewController;
    viewController.delegate = self;
  }
  else {
    SBModalViewController *viewController = segue.destinationViewController;
    viewController.view.frame = self.parentRect;
    self.animator = [[ZFModalTransitionAnimator alloc] initWithModalViewController:viewController];
    self.animator.dragable = YES;
    self.animator.direction = ZFModalTransitonDirectionBottom|ZFModalTransitonDirectionTop;

    // set transition delegate of modal view controller to our object
    viewController.transitioningDelegate = self.animator;
    viewController.modalPresentationStyle = UIModalPresentationCustom;
    viewController.delegate = self;

    if ([segue.identifier isEqualToString:kScorePreviewSegue] || [segue.identifier isEqualToString:kScoreShowSegue]) {
      viewController.game = self.selectedGame;

      if ([segue.identifier isEqualToString:kScorePreviewSegue]) {
        [self.animator setContentScrollView:((SBPreviewViewController *)viewController).tableView];
      }
      else if ([segue.identifier isEqualToString:kScoreShowSegue]) {
        [self.animator setContentScrollView:((SBBoxscoreViewController *)viewController).tableView];
      }
    }
  }
}


@end
