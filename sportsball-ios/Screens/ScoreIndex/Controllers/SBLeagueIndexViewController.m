//
//  LeagueViewController.m
//  sportsball-ios
//
//  Created by Mike Silvis on 11/6/14.
//  Copyright (c) 2014 Mike Silvis. All rights reserved.
//

#import "SBLeagueIndexViewController.h"
#import "UIImage+FontAwesome.h"
#import "SBUser.h"
#import "SBBoxscoreViewController.h"
#import "SBScorePreviewViewController.h"
#import <MPGNotification.h>
#import "EDColor.h"
#import "SBConstants.h"

@implementation SBLeagueIndexViewController

static  NSString *kScoreShowSegue = @"scoreShowSegue";
static  NSString *kScorePreviewSegue = @"kScorePreviewSegue";

- (void)viewDidLoad {
  [super viewDidLoad];

  self.scoreViews = [NSMutableArray array];
  self.leagues = [SBUser currentUser].leagues;

  // Create the table list
  self.paginalTableView = [[APPaginalTableView alloc] initWithFrame:self.view.bounds];
  self.paginalTableView.dataSource = self;
  self.paginalTableView.delegate = self;
  self.paginalTableView.tableView.separatorColor = [UIColor whiteColor];
  self.paginalTableView.tableView.separatorInset = UIEdgeInsetsZero;
  self.paginalTableView.tableView.layoutMargins = UIEdgeInsetsZero;
  self.paginalTableView.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
  self.paginalTableView.tableView.backgroundColor = [UIColor clearColor];
  self.paginalTableView.backgroundColor = [UIColor clearColor];
  [self.view insertSubview:self.paginalTableView belowSubview:self.toolBar];
  
  // Create the page control
  self.pageControl = [[UIPageControl alloc] init];
  self.pageControl.numberOfPages = self.leagues.count;
  self.pageControl.currentPage = 1;
  self.pageControl.frame = CGRectMake(0,
                                      (self.view.bounds.size.height - self.tabBarController.tabBar.frame.size.height - 30),
                                      200,
                                      50
                                     );
  [self.pageControl sizeToFit];
  CGRect f = self.pageControl.frame;
  f.origin.x = (self.view.bounds.size.width - self.pageControl.bounds.size.width) / 2;
  self.pageControl.frame = f;
  self.pageControl.hidden = YES;
  [self.view addSubview:self.pageControl];

  CGFloat iconSize = 25;
  FAKFontAwesome *hamburgerIcon = [FAKFontAwesome barsIconWithSize:iconSize];
  self.hamburgerButton.image = [UIImage imageWithFontAwesomeIcon:hamburgerIcon andSize:iconSize andColor:@"#fff"];

  self.toolBar.backgroundColor = [UIColor clearColor];
  [self.toolBar setBackgroundImage:[UIImage new]
                forToolbarPosition:UIToolbarPositionAny
                        barMetrics:UIBarMetricsDefault];
  self.toolBar.clipsToBounds = YES;
  self.toolBar.hidden = YES;

  [[NSNotificationCenter defaultCenter] addObserver:self
                                           selector:@selector(stopTimer)
                                               name:UIApplicationDidEnterBackgroundNotification
                                             object:nil];

  [[NSNotificationCenter defaultCenter] addObserver:self
                                           selector:@selector(startTimer)
                                               name:UIApplicationDidBecomeActiveNotification
                                             object:nil];
  [[NSNotificationCenter defaultCenter] addObserver:self
                                               selector:@selector(hideMenuIems:)
                                                   name:kNotificationHideEvent object:nil];

  self.tabBarController.tabBar.hidden = YES;
  [self openAtLastSelectedIndex];
  [self buildHelpIcon];
}

- (void)hideMenuIems:(NSNotification *)notification {
  bool alphaHidden = [(NSNumber *)notification.object[@"alpha"] boolValue];

  int openedIndex = [[SBUser currentUser].lastOpenedLeagueIndex intValue];
  if ((openedIndex >= 0) && (self.scoreViews)[openedIndex]) {
    self.toolBar.hidden = alphaHidden;
  }
}

- (void)buildHelpIcon {
  CGFloat iconSize = 30;
  FAKFontAwesome *questionImage = [FAKFontAwesome questionCircleIconWithSize:iconSize];
  [self.supportButton setImage:[UIImage imageWithFontAwesomeIcon:questionImage andSize:iconSize andColor:@"#fffff"] forState:UIControlStateNormal];
  [self.supportButton setTitle:@"" forState:UIControlStateNormal];
  [self.supportButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
  [self.supportButton setTintColor:[UIColor whiteColor]];
}

- (void)openAtLastSelectedIndex {
  if (![SBUser currentUser].lastOpenedLeagueIndex) {
    return;
  }

  int openedIndex = [[SBUser currentUser].lastOpenedLeagueIndex intValue];

  if ((openedIndex >= 0) && (self.scoreViews)[openedIndex]) {
    [self openScoresAtIndex:openedIndex animated:NO];
  }
}

- (void)viewDidAppear:(BOOL)animated {
  [super viewDidAppear:animated];

  [self startTimer];
}

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

- (void)paginalTableView:(APPaginalTableView *)paginalTableView didChangeIndex:(NSUInteger)index {
  [self stopTimer];
  [self startTimer];
}

- (void)startTimer {
  if (self.scoreViews.count >= self.paginalTableView.indexOpenedElement) {
    self.pageControl.currentPage = self.paginalTableView.indexOpenedElement;

    [SBUser currentUser].lastOpenedLeagueIndex = @(self.paginalTableView.indexOpenedElement);
    [SBUser currentUser].lastOpenedLeague = self.leagues[self.paginalTableView.indexOpenedElement];
    [self.scoreViews[self.paginalTableView.indexOpenedElement] startTimer];
  }
}

- (void)stopTimer {
  for (SBScoreIndexView *view in self.scoreViews) {
    [view cancelTimer];
  }
}

- (IBAction)didRequestClose:(id)sender {
  [SBUser currentUser].lastOpenedLeague = nil;
  [SBUser currentUser].lastOpenedLeagueIndex = @-1;
  [self closeWindow];
}

-(void)closeWindow {
  self.pageControl.hidden = YES;
  self.toolBar.hidden = YES;
  self.supportButton.hidden = NO;
  self.tabBarController.tabBar.hidden = YES;
  [self.paginalTableView closeElementWithCompletion:nil animated:YES];
}

-(void)openScoresAtIndex:(NSUInteger)index animated:(BOOL)animated {
  [self.paginalTableView openElementAtIndex:index completion:^(BOOL completed) {
    if (completed) {
      self.tabBarController.tabBar.hidden = NO;
      self.pageControl.hidden = NO;
      self.toolBar.hidden = NO;
      self.supportButton.hidden = YES;
    }
  } animated:animated];
}

- (NSUInteger)numberOfElementsInPaginalTableView:(APPaginalTableView *)managerView {
    return self.leagues.count;
}

- (UIView *)paginalTableView:(APPaginalTableView *)paginalTableView collapsedViewAtIndex:(NSUInteger)index
{
    UIView *collapsedView = [self createCollapsedViewAtIndex:index];
    return collapsedView;
}

- (UIView *)paginalTableView:(APPaginalTableView *)paginalTableView expandedViewAtIndex:(NSUInteger)index
{
    UIView *expandedView = [self createExpandedViewAtIndex:index];
    return expandedView;
}

#pragma mark - APPaginalTableViewDelegate

- (BOOL)paginalTableView:(APPaginalTableView *)managerView
      openElementAtIndex:(NSUInteger)index
      onChangeHeightFrom:(CGFloat)initialHeight
                toHeight:(CGFloat)finalHeight
{
  BOOL open = _paginalTableView.isExpandedState;
  APPaginalTableViewElement *element = [managerView elementAtIndex:index];

  // Open
  if (initialHeight > finalHeight) {
    open = finalHeight > element.expandedHeight * 0.8f;
  }
  // Close
  else if (initialHeight < finalHeight) {
    open = finalHeight > element.expandedHeight * 0.2f;
  }

  SBScoreIndexView *scoreView = self.scoreViews[index];
  [scoreView cancelTimer];
  self.pageControl.hidden = YES;
  self.toolBar.hidden = YES;

  return open;
}

- (void)paginalTableView:(APPaginalTableView *)paginalTableView didSelectRowAtIndex:(NSUInteger)index {
  [self openScoresAtIndex:index animated:YES];
}

- (UIView *)createCollapsedViewAtIndex:(NSUInteger)index {
  CGFloat cellHeight = 100;

  SBLeagueIndexHeader *leagueHeader = [[[NSBundle mainBundle] loadNibNamed:@"SBLeagueIndexHeader" owner:nil options:nil] lastObject];
  leagueHeader.frame = CGRectMake(0, 0, CGRectGetWidth(self.view.bounds), cellHeight);
  leagueHeader.league = self.leagues[index];

  return leagueHeader;
}

- (UIView *)createExpandedViewAtIndex:(NSUInteger)index {
  SBScoreIndexView *scoreIndex = [[[NSBundle mainBundle] loadNibNamed:@"SBScoreIndexView" owner:nil options:nil] lastObject];
  scoreIndex.league = self.leagues[index];
  scoreIndex.frame = CGRectMake(0,
                                0,
                                self.view.bounds.size.width,
                                (self.view.bounds.size.height - self.tabBarController.tabBar.frame.size.height)
                               );
  scoreIndex.delegate = self;
  [self.scoreViews addObject:scoreIndex];

  return scoreIndex;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
  SBModalViewController *viewController = segue.destinationViewController;
  viewController.view.frame = self.view.bounds;
  self.animator = [[ZFModalTransitionAnimator alloc] initWithModalViewController:viewController];
  self.animator.dragable = YES;
  self.animator.direction = ZFModalTransitonDirectionBottom|ZFModalTransitonDirectionTop;

  // set transition delegate of modal view controller to our object
  viewController.transitioningDelegate = self.animator;
  viewController.modalPresentationStyle = UIModalPresentationCustom;

  if ([segue.identifier isEqualToString:kScorePreviewSegue] || [segue.identifier isEqualToString:kScoreShowSegue]) {
    viewController.game = self.selectedGame;
    viewController.delegate = self;
    
    if ([segue.identifier isEqualToString:kScorePreviewSegue]) {
      [self.animator setContentScrollView:((SBScorePreviewViewController *)viewController).tableView];
    }
    else if ([segue.identifier isEqualToString:kScoreShowSegue]) {
      [self.animator setContentScrollView:((SBBoxscoreViewController *)viewController).tableView];
    }
  }

  [self stopTimer];
}

- (void)dismissedModal {
  [self startTimer];
}

- (void)requestClose {
  [self closeWindow];
}

- (UIStatusBarStyle)preferredStatusBarStyle{
  return UIStatusBarStyleLightContent;
}

- (void)requestFailed:(NSError *)error {
  [self showNetworkError:error];
}

- (void)askForFavoriteTeam:(SBTeam *)team {
  if (self.isNotificationOpen) {
    return;
  }

  if ([team parseObject][@"pushEnabled"] != nil) {
    return;
  }

  self.isNotificationOpen = YES;
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
      self.isNotificationOpen = NO;
    }
    else if (buttonIndex == notification.secondButton.tag) {
      [self registerNoPushForTeam:(SBTeam *)team];
      self.isNotificationOpen = NO;
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

@end
