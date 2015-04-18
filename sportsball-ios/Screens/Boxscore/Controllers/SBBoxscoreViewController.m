//
//  ScoreShowViewController.m
//  sportsball-ios
//
//  Created by Mike Silvis on 11/13/14.
//  Copyright (c) 2014 Mike Silvis. All rights reserved.
//

#import "SBBoxscoreViewController.h"
#import "SBScoreSummaryViewCell.h"
#import "SBScoreDetailCollectionViewCell.h"
#import "SBContentTableViewCell.h"
#import "UIImage+FontAwesome.h"
#import "SBScoreDataTableViewCell.h"
#import "SBUser.h"
#import "SBTeamStatsTableViewCell.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import <Pusher/Pusher.h>
#import "SBConstants.h"
#import <Mixpanel.h>

@interface SBBoxscoreViewController ()

@property (nonatomic, strong) PTPusherChannel *channel;

@end

@implementation SBBoxscoreViewController

static NSString * const kScoreSummaryViewCell = @"ScoreSummaryViewCell";
static NSString * const kScoreDetailCollectionViewCell = @"ScoreDetailCollectionViewCell";
static NSString * const kScoreRecapCollectionViewCell = @"ScoreRecapCollectionViewCell";
static NSString * const kScoreDataCell = @"ScoreDataCell";
static NSString * const kTeamStatsCell = @"teamStatsCell";

static NSString * const kWebViewSegue = @"webViewSegue";

static const NSInteger kScoreSummaryViewLocation = 0;
static const NSInteger kScoreRecapViewLocation   = 1;
static const NSInteger kScoreDetailViewLocation  = 2;
static const NSInteger kTeamStatsLocation        = 3;
static const NSInteger kScoreDataViewLocation    = 4;

- (void)viewDidLoad {
  [super viewDidLoad];

  // Collection View Styles
  self.tableView.backgroundColor = [UIColor clearColor];
  self.tableView.indicatorStyle = UIScrollViewIndicatorStyleWhite;

  // Register nibs
  [self.tableView registerNib:[UINib nibWithNibName:@"SBScoreSummaryViewCell" bundle:nil]
       forCellReuseIdentifier:kScoreSummaryViewCell];
  [self.tableView registerNib:[UINib nibWithNibName:@"SBScoreDetailCollectionViewCell" bundle:nil]
       forCellReuseIdentifier:kScoreDetailCollectionViewCell];
  [self.tableView registerNib:[UINib nibWithNibName:@"SBContentTableViewCell" bundle:nil]
       forCellReuseIdentifier:kScoreRecapCollectionViewCell];
  [self.tableView registerNib:[UINib nibWithNibName:@"SBScoreDataTableViewCell" bundle:nil]
       forCellReuseIdentifier:kScoreDataCell];
  [self.tableView registerNib:[UINib nibWithNibName:@"SBTeamStatsTableViewCell" bundle:nil]
       forCellReuseIdentifier:kTeamStatsCell];

  // Close Icon
  CGFloat iconSize = 25;
  FAKFontAwesome *closeIcon = [FAKFontAwesome timesIconWithSize:iconSize];
  [self.closeButton setImage:[UIImage imageWithFontAwesomeIcon:closeIcon andSize:iconSize andColor:@"#fff"] forState:UIControlStateNormal];
  [self.closeButton setTitle:@"" forState:UIControlStateNormal];
  [self.closeButton addTarget:self action:@selector(closeModal) forControlEvents:UIControlEventTouchDown];

  self.loadingIndicator.hidden = YES;
}

- (void)closeModal {
  [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)viewWillAppear:(BOOL)animated {
  [super viewWillAppear:animated];

  if (!self.game.boxscore) {
    self.loadingIndicator.hidden = NO;
  }

  [self findBoxscore];
  [self setHeaderInfo];
}

- (void)viewDidDisappear:(BOOL)animated {
  [super viewDidDisappear:animated];

  [self.channel unsubscribe];
}

- (void)findBoxscore {
  if (!self.game.boxscoreId) {
    self.loadingIndicator.hidden = YES;
    return;
  }

  [self.game findBoxscore:nil success:^(SBBoxscore *boxscore) {
    self.game.boxscore = boxscore;
    self.game.awayTeam = boxscore.awayTeam;
    self.game.homeTeam = boxscore.homeTeam;
    [self setHeaderInfo];
    
    self.loadingIndicator.hidden = YES;

    [self.tableView reloadData];
  } failure:^(NSError *error) {
    [self showNetworkError:error];
  }];
}

- (void)setGame:(SBGame *)game {
  [super setGame:game];

  [self.tableView reloadData];

  if (self.game.isInProgress) {
    [self connectToChannel];
  }

  [self setHeaderInfo];
}

- (void)connectToChannel {
  if (!self.game.boxscoreId) {
    return;
  }

  NSString *channelName = [NSString stringWithFormat:@"boxscore_%@_%@", self.game.leagueName, self.game.boxscoreId];
  self.channel = [[SBUser currentUser].client subscribeToChannelNamed:channelName];

  [self.channel bindToEventNamed:@"event" handleWithBlock:^(PTPusherEvent *channelEvent) {
    self.game          = [[SBGame alloc] initWithJson:channelEvent.data[@"game"]];
    self.game.boxscore = [[SBBoxscore alloc] initWithJson:channelEvent.data[@"boxscore"]];
    [self.tableView reloadData];
  }];
}

- (void)setHeaderInfo {
  SBTeam *homeTeam = self.game.homeTeam;
  self.homeTeamScore.text = self.game.homeScoreString;

  SBTeam *awayTeam = self.game.awayTeam;
  self.awayTeamScore.text = self.game.awayScoreString;

  if ([SBUser currentUser].teamLogos) {
    [self.awayTeamLogo sd_setImageWithURL:[awayTeam imageURL:awayTeam.logoUrl withSize:@"120x120"]];
    [self.homeTeamLogo sd_setImageWithURL:[homeTeam imageURL:homeTeam.logoUrl withSize:@"120x120"]];
    self.awayTeamName.text = @"";
    self.homeTeamName.text = @"";
  }
  else {
    self.homeTeamName.text = homeTeam.abbr;
    self.awayTeamName.text = awayTeam.abbr;
  }
}

#pragma mark - Table Stuff

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
  return 5;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
  return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  if (indexPath.section == kScoreSummaryViewLocation) {
    SBScoreSummaryViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kScoreSummaryViewCell forIndexPath:indexPath];
    cell.game = self.game;

    return cell;
  }
  else if (indexPath.section == kScoreRecapViewLocation) {
    SBContentTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kScoreRecapCollectionViewCell forIndexPath:indexPath];
    cell.game = self.game;
    cell.recap = self.game.boxscore.recap;

    return cell;
  }
  else if (indexPath.section == kScoreDetailViewLocation){
    SBScoreDetailCollectionViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kScoreDetailCollectionViewCell forIndexPath:indexPath];
    cell.game = self.game;
    cell.scoreDetails = self.game.boxscore.scoreDetail;

    return cell;
  }
  else if (indexPath.section == kTeamStatsLocation) {
    SBTeamStatsTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kTeamStatsCell forIndexPath:indexPath];
    cell.gameStats = self.game.boxscore.gameStats;

    return cell;
  }
  else if (indexPath.section == kScoreDataViewLocation) {
    SBScoreDataTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kScoreDataCell forIndexPath:indexPath];
    cell.game = self.game;

    return cell;
  }

  return nil;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
  if (indexPath.section == kScoreRecapViewLocation) {
    [[Mixpanel sharedInstance] track:@"openedBoxscoreURL"];
    [self openURL:self.game.boxscore.recap.url];
  }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
  CGFloat width = self.view.bounds.size.width;

  if (indexPath.section == kScoreSummaryViewLocation) {
    return [SBScoreSummaryViewCell measureCellSizeWithResource:self.game.boxscore.scoreSummary andWidth:width].height;
  }
  else if (indexPath.section == kScoreRecapViewLocation) {
    return [SBContentTableViewCell measureCellSizeWithResource:self.game andWidth:width].height;
  }
  else if (indexPath.section == kScoreDetailViewLocation) {
    return [SBScoreDetailCollectionViewCell measureCellSizeWithResource:self.game.boxscore.scoreDetail andWidth:width].height;
  }
  else if (indexPath.section == kTeamStatsLocation) {
    return [SBTeamStatsTableViewCell measureCellSizeWithResource:self.game.boxscore.gameStats andWidth:width].height;
  }
  else if (indexPath.section == kScoreDataViewLocation) {
    return [SBScoreDataTableViewCell measureCellSizeWithResource:self.game andWidth:width].height;
  }
  else {
    return 0;
  }
}

- (BOOL)shouldRecieveDrag:(UIGestureRecognizer *)gestureRecognizer {
  CGPoint touchPoint = [gestureRecognizer locationInView:self.view];
  CGRect scoreSummary = [self.tableView rectForSection:kScoreSummaryViewLocation];
  CGRect rectInSuperview = [self.tableView convertRect:scoreSummary toView:[self.tableView superview]];

  CGFloat begin = rectInSuperview.origin.y;
  CGFloat touchPointAY = touchPoint.y;
  CGFloat totalHeight = rectInSuperview.size.height + rectInSuperview.origin.y;

  if ((begin < touchPointAY) && (touchPointAY < totalHeight)) {
    return NO;
  }

  return YES;
}

@end