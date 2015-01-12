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
#import "ScoreSummaryViewCell.h"
#import "ScoreDetailCollectionViewCell.h"
#import "ContentTableViewCell.h"
#import <UIImageView+AFNetworking.h>
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

  // Collection View Styles
  self.tableView.backgroundColor = [UIColor clearColor];

  // Register nibs
  [self.tableView registerNib:[UINib nibWithNibName:@"ScoreSummaryViewCell" bundle:nil]
        forCellReuseIdentifier:scoreSummaryViewCell];

  [self.tableView registerNib:[UINib nibWithNibName:@"ScoreDetailCollectionViewCell" bundle:nil]
        forCellReuseIdentifier:scoreDetailCollectionViewCell];

  [self.tableView registerNib:[UINib nibWithNibName:@"ContentTableViewCell" bundle:nil]
        forCellReuseIdentifier:scoreRecapCollectionViewCell];

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
  }

  [self.game findBoxscore:nil success:^(Boxscore *boxscore) {
    self.game.boxscore = boxscore;
    self.loadingIndicator.hidden = YES;

    [self.tableView reloadData];
  } failure:nil];

  [self setHeaderInfo];
}

-(void)setGame:(Game *)game {
  [super setGame:game];

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
}

-(void)dismissViewControllerAnimated:(BOOL)flag completion:(void (^)(void))completion {
  [super dismissViewControllerAnimated:flag completion:^{
    [self.delegate dismissedModal];
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
    ScoreSummaryViewCell *cell = [tableView dequeueReusableCellWithIdentifier:scoreSummaryViewCell forIndexPath:indexPath];
    cell.game = self.game;

    return cell;
  }
  else if (indexPath.section == scoreRecapViewLocation) {
    ContentTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:scoreRecapCollectionViewCell forIndexPath:indexPath];
    cell.recap = self.game.boxscore.recap;

    return cell;
  }
  else if (indexPath.section == scoreDetailViewLocation){
    ScoreDetailCollectionViewCell *cell = [tableView dequeueReusableCellWithIdentifier:scoreDetailCollectionViewCell forIndexPath:indexPath];
    cell.game = self.game;
    cell.scoreDetails = self.game.boxscore.scoreDetail;

    return cell;
  }

  return nil;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
  if (indexPath.section == scoreRecapViewLocation) {
    [self openURL:self.game.boxscore.recap.url];
  }
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
  if (indexPath.section == scoreSummaryViewLocation) {
    return [ScoreSummaryViewCell measureCellSizeWithResource:self.game.boxscore.scoreSummary andWidth:self.view.bounds.size.width].height;
  }
  else if (indexPath.section == scoreRecapViewLocation) {
    return [ContentTableViewCell measureCellSizeWithResource:self.game andWidth:self.view.bounds.size.width].height;
  }
  else if (indexPath.section == scoreDetailViewLocation) {
    return [ScoreDetailCollectionViewCell measureCellSizeWithResource:self.game.boxscore.scoreDetail andWidth:self.view.bounds.size.width].height;
  }
  else {
    return 0;
  }
}

@end