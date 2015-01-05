//
//  ScoreShowViewController.m
//  sportsball-ios
//
//  Created by Mike Silvis on 11/13/14.
//  Copyright (c) 2014 Mike Silvis. All rights reserved.
//

#import "ScoreShowViewController.h"
#import "CSStickyHeaderFlowLayout.h"
#import "LeagueHeader.h"
#import "ScoreSummaryCollectionViewCell.h"
#import "ScoreDetailCollectionViewCell.h"
#import "RecapCollectionViewCell.h"
#import <UIImageView+AFNetworking.h>
#import "SVModalWebViewController.h"
#import "UIImage+FontAwesome.h"

@implementation ScoreShowViewController

static NSString * const scoreSummaryViewCell = @"scoreSummaryViewCell";
static NSString * const scoreDetailCollectionViewCell = @"scoreDetailCollectionViewCell";
static NSString * const scoreRecapCollectionViewCell = @"scoreRecapCollectionViewCell";

static NSString * const WebViewSegue = @"webViewSegue";

static const NSInteger scoreSummaryViewLocation = 0;
static const NSInteger scoreRecapViewLocation   = 1;
static const NSInteger scoreDetailViewLocation  = 2;

- (void)viewDidLoad {
  [super viewDidLoad];
  self.view.backgroundColor = [UIColor clearColor];

  // Collection View Styles
  self.tableView.backgroundColor = [UIColor clearColor];
  self.tableView.indicatorStyle = UIScrollViewIndicatorStyleWhite;
  self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;

  // Blur effect
  UIBlurEffect *blur = [UIBlurEffect effectWithStyle:UIBlurEffectStyleDark];
  self.blurView = [[UIVisualEffectView alloc] initWithEffect:blur];
  [self.view addSubview:self.blurView];
  [self.view sendSubviewToBack:self.blurView];

  // Register nibs
  [self.tableView registerNib:[UINib nibWithNibName:@"ScoreSummaryViewCell" bundle:nil]
        forCellReuseIdentifier:scoreSummaryViewCell];

  [self.tableView registerNib:[UINib nibWithNibName:@"ScoreDetailCollectionViewCell" bundle:nil]
        forCellReuseIdentifier:scoreDetailCollectionViewCell];

  [self.tableView registerNib:[UINib nibWithNibName:@"RecapCollectionViewCell" bundle:nil]
        forCellReuseIdentifier:scoreRecapCollectionViewCell];
}

-(void)viewWillAppear:(BOOL)animated {
  [super viewWillAppear:animated];

  [self.game findBoxscore:nil success:^(Boxscore *boxscore) {
    self.game.boxscore = boxscore;

    [self.tableView reloadData];
  } failure:nil];

  [self setHeaderInfo];
}

-(void)setGame:(Game *)game {
  _game = game;

  [self.tableView reloadData];

  [self setHeaderInfo];
}

-(void)setHeaderInfo {
  Team *homeTeam = self.game.homeTeam;
  [self.homeTeamLogo setImageWithURL:[homeTeam imageURLWithSize:homeTeam.logoUrl andSize:@"120x120"]];
  self.homeTeamScore.text = self.game.homeScoreString;

  Team *awayTeam = self.game.awayTeam;
  [self.awayTeamLogo setImageWithURL:[awayTeam imageURLWithSize:awayTeam.logoUrl andSize:@"120x120"]];
  self.awayTeamScore.text = self.game.awayScoreString;

  if (self.game.isPregame) {
    // Scores
    self.awayTeamScore.hidden = YES;
    self.homeTeamScore.hidden = YES;

    // Background
    self.upperInfo.hidden = NO;
    self.lowerInfo.hidden = NO;
    self.upperInfo.text = self.game.moneyLine;
    self.lowerInfo.text = self.game.localStartTime;
  }
  else if (self.game.isInProgress) {
    // Scores
    self.awayTeamScore.hidden = NO;
    self.homeTeamScore.hidden = NO;

    // Game Clock
    self.upperInfo.hidden = NO;
    self.lowerInfo.hidden = NO;
    self.lowerInfo.text = self.game.timeRemaining;
    self.upperInfo.text = self.game.currentPeriod;
  }
  else {
    // Scores
    self.awayTeamScore.hidden = NO;
    self.homeTeamScore.hidden = NO;

    // Game Summary
    self.lowerInfo.hidden = NO;
    self.upperInfo.hidden = YES;
    self.lowerInfo.text = self.game.endedIn;
  }
}

-(void)viewWillLayoutSubviews {
  [super viewWillLayoutSubviews];

  // Blur
  self.blurView.frame = self.view.frame;
}

-(void)dismissViewControllerAnimated:(BOOL)flag completion:(void (^)(void))completion {
  [super dismissViewControllerAnimated:flag completion:^{
    [self.delegate dismissedScoreShowViewModal];
  }];
}

#pragma mark 

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
  return 3;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
  return 1;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  if (indexPath.section == scoreSummaryViewLocation) {
    ScoreSummaryCollectionViewCell *cell = [tableView dequeueReusableCellWithIdentifier:scoreSummaryViewCell forIndexPath:indexPath];
    cell.scoreSummary = self.game.boxscore.scoreSummary;
    cell.selectionStyle = UITableViewCellSeparatorStyleNone;

    return cell;
  }
  else if (indexPath.section == scoreRecapViewLocation) {
    RecapCollectionViewCell *cell = [tableView dequeueReusableCellWithIdentifier:scoreRecapCollectionViewCell forIndexPath:indexPath];
    cell.recap = self.game.boxscore.recap;
    cell.selectionStyle = UITableViewCellSeparatorStyleNone;

    return cell;
  }
  else if (indexPath.section == scoreDetailViewLocation){
    ScoreDetailCollectionViewCell *cell = [tableView dequeueReusableCellWithIdentifier:scoreDetailCollectionViewCell forIndexPath:indexPath];
    cell.game = self.game;
    cell.scoreDetails = self.game.boxscore.scoreDetail;
    cell.selectionStyle = UITableViewCellSeparatorStyleNone;

    return cell;
  }

  return nil;
}

-(void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath {
  if (indexPath.section == scoreRecapViewLocation) {
    SVModalWebViewController *webViewController = [[SVModalWebViewController alloc] initWithURL:self.game.boxscore.recap.url];
    webViewController.modalPresentationStyle = UIModalPresentationPageSheet;
    webViewController.title = @"";
    [self presentViewController:webViewController animated:YES completion:NULL];
  }

  return;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
  if (indexPath.section == scoreRecapViewLocation) {
    SVModalWebViewController *webViewController = [[SVModalWebViewController alloc] initWithURL:self.game.boxscore.recap.url];
    webViewController.modalPresentationStyle = UIModalPresentationPageSheet;
    webViewController.title = @"";
    [self presentViewController:webViewController animated:YES completion:NULL];
  }

  return;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
  if (indexPath.section == scoreSummaryViewLocation) {
    return [ScoreSummaryCollectionViewCell measureCellSizeWithResource:self.game.boxscore.scoreSummary andWidth:self.view.bounds.size.width].height;
  }
  else if (indexPath.section == scoreRecapViewLocation) {
    return [RecapCollectionViewCell measureCellSizeWithResource:self.game andWidth:self.view.bounds.size.width].height;
  }
  else if (indexPath.section == scoreDetailViewLocation) {
    return [ScoreDetailCollectionViewCell measureCellSizeWithResource:self.game.boxscore.scoreDetail andWidth:self.view.bounds.size.width].height;
  }
  else {
    return 0;
  }
}

@end