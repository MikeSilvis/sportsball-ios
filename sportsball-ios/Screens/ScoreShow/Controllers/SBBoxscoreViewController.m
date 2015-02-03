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
#import <MPGNotification/MPGNotification.h>

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

-(void)closeModal {
  [self dismissViewControllerAnimated:YES completion:nil];
}

-(void)viewWillAppear:(BOOL)animated {
  [super viewWillAppear:animated];

  if (!self.game.boxscore) {
    self.loadingIndicator.hidden = NO;
    [self findBoxscore];
  }

  [self setHeaderInfo];
}

-(void)findBoxscore {
  if (!self.game.boxscoreId) {
    self.loadingIndicator.hidden = YES;
    return;
  }

  [self.game findBoxscore:nil success:^(SBBoxscore *boxscore) {
    self.game.boxscore = boxscore;
    self.loadingIndicator.hidden = YES;

    [self.tableView reloadData];
  } failure:^(NSError *error) {
    [self showNetworkError:error];
  }];
}

-(void)setGame:(SBGame *)game {
  [super setGame:game];

  [self.tableView reloadData];

  [self setHeaderInfo];
}

-(void)setHeaderInfo {
  SBTeam *homeTeam = self.game.homeTeam;
  [self.homeTeamLogo sd_setImageWithURL:[homeTeam imageURL:homeTeam.logoUrl withSize:@"120x120"]];
  self.homeTeamScore.text = self.game.homeScoreString;

  SBTeam *awayTeam = self.game.awayTeam;
  [self.awayTeamLogo sd_setImageWithURL:[awayTeam imageURL:awayTeam.logoUrl withSize:@"120x120"]];
  self.awayTeamScore.text = self.game.awayScoreString;
}

-(void)dismissViewControllerAnimated:(BOOL)flag completion:(void (^)(void))completion {
  [super dismissViewControllerAnimated:flag completion:^{
    [self.delegate dismissedModal];
  }];
}

#pragma mark 

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
  return 5;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
  return 1;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  if (indexPath.section == kScoreSummaryViewLocation) {
    SBScoreSummaryViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kScoreSummaryViewCell forIndexPath:indexPath];
    cell.game = self.game;

    return cell;
  }
  else if (indexPath.section == kScoreRecapViewLocation) {
    SBContentTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kScoreRecapCollectionViewCell forIndexPath:indexPath];
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

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
  if (indexPath.section == kScoreRecapViewLocation) {
    [self openURL:self.game.boxscore.recap.url];
  }
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
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

@end