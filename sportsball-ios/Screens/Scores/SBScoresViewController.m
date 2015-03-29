//
//  SBScoresViewController.m
//  sportsball-ios
//
//  Created by Mike Silvis on 3/27/15.
//  Copyright (c) 2015 Mike Silvis. All rights reserved.
//

#import "SBScoresViewController.h"
#import "SBScoreIndexViewCell.h"
#import "SBModalViewController.h"
#import "SBBoxscoreViewController.h"
#import "SBScorePreviewViewController.h"
#import "SBModalViewController.h"

#import "SBUser.h"
#import <MPGNotification.h>
#import "EDColor.h"

@interface SBScoresViewController () <SBScoreIndexViewCellDelegate, SBModalDelegate>

@property (nonatomic, strong) SBGame *selectedGame;
@property (nonatomic, strong) SBScoreIndexViewCell *currentScoreIndex;

@end

@implementation SBScoresViewController

static NSString * const kPagingSegue = @"pagingSegue";
static NSString * const kScoreIndexViewCell = @"scoreIndexViewCell";

static  NSString *kScoreShowSegue = @"scoreShowSegue";
static  NSString *kScorePreviewSegue = @"kScorePreviewSegue";

#pragma mark - Collection View

- (void)defineCells:(UICollectionView *)collectionView {
  [collectionView registerNib:[UINib nibWithNibName:@"SBScoreIndexViewCell" bundle:nil]
        forCellWithReuseIdentifier:kScoreIndexViewCell];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
  SBScoreIndexViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kScoreIndexViewCell forIndexPath:indexPath];
  cell.league = [SBUser currentUser].leagues[indexPath.row];
  cell.delegate = self;

  NSLog(@"adding league: %@ for: %ld", cell.league.name, (long)indexPath.row );

  return cell;
}

- (void)cellDidAppear:(UICollectionViewCell *)cell {
  self.currentScoreIndex = (SBScoreIndexViewCell *)cell;
  [self.currentScoreIndex startTimer];
}

- (void)cellDidDisappear:(UICollectionViewCell *)cell {
  [((SBScoreIndexViewCell *)cell) cancelTimer];
}

#pragma mark - Delegate Methods

- (void)selectedGame:(SBGame *)game {
  self.selectedGame = game;

  [[SBUser currentUser] appendFavoriteTeams:game.homeTeam andTeam:game.awayTeam andLeague:game.leagueName];

  if (game.isPregame) {
    [self performSegueWithIdentifier:kScorePreviewSegue sender:self];
  }
  else {
    [self performSegueWithIdentifier:kScoreShowSegue sender:self];
  }
}

- (void)dismissedModal {
  [self.currentScoreIndex cancelTimer];

  [self.currentScoreIndex startTimer];
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

#pragma mark - Segues

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
  if ([segue.identifier isEqualToString:kPagingSegue]) {
    SBPagingViewController *destinationViewController = segue.destinationViewController;
    destinationViewController.delegate = self;
  }
  else {
  SBModalViewController *viewController = segue.destinationViewController;
  viewController.view.frame = self.view.bounds;
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
      [self.animator setContentScrollView:((SBScorePreviewViewController *)viewController).tableView];
    }
    else if ([segue.identifier isEqualToString:kScoreShowSegue]) {
      [self.animator setContentScrollView:((SBBoxscoreViewController *)viewController).tableView];
    }
  }
  }
}


@end
