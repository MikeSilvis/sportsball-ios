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

@implementation ScoreShowViewController

static NSString * const scoreSummaryViewCell = @"scoreSummaryViewCell";
static NSString * const scoreDetailCollectionViewCell = @"scoreDetailCollectionViewCell";
static NSString * const scoreRecapCollectionViewCell = @"scoreRecapCollectionViewCell";

static NSString * const WebViewSegue = @"webViewSegue";

static const NSInteger scoreSummaryViewLocation = 0;
static const NSInteger scoreRecapViewLocation   = 1;
static const NSInteger scoreDetailViewLocation  = 2;

static int headerSize = 0;

- (void)viewDidLoad {
  [super viewDidLoad];
  self.view.backgroundColor = [UIColor clearColor];

  // Collection View Styles
  self.collectionView.backgroundColor = [UIColor clearColor];
  self.collectionView.indicatorStyle = UIScrollViewIndicatorStyleWhite;

  // Blur effect
  self.background.backgroundColor = [UIColor clearColor];
  UIBlurEffect *blur = [UIBlurEffect effectWithStyle:UIBlurEffectStyleDark];
  self.blurView = [[UIVisualEffectView alloc] initWithEffect:blur];
  [self.view insertSubview:self.blurView belowSubview:self.background];

  // Background Touch (for closing the modal)
  UITapGestureRecognizer *backgroundRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(backgroundTapped:)];
  backgroundRecognizer.delegate = self;
  [self.view addGestureRecognizer:backgroundRecognizer];

  // Register nibs
  [self.collectionView registerNib:[UINib nibWithNibName:@"ScoreSummaryViewCell" bundle:nil]
        forCellWithReuseIdentifier:scoreSummaryViewCell];

  [self.collectionView registerNib:[UINib nibWithNibName:@"ScoreDetailCollectionViewCell" bundle:nil]
        forCellWithReuseIdentifier:scoreDetailCollectionViewCell];

  [self.collectionView registerNib:[UINib nibWithNibName:@"RecapCollectionViewCell" bundle:nil]
        forCellWithReuseIdentifier:scoreRecapCollectionViewCell];
}

-(void)viewWillAppear:(BOOL)animated {
  [super viewWillAppear:animated];

  [self.game findBoxscore:nil success:^(Boxscore *boxscore) {
    self.game.boxscore = boxscore;

    [self.collectionView reloadData];
  } failure:nil];

  [self setHeaderInfo];
}

-(void)setGame:(Game *)game {
  _game = game;

  [self.collectionView reloadData];

  [self setHeaderInfo];
}

-(void)setHeaderInfo {
  Team *homeTeam = self.game.homeTeam;
  [self.homeTeamLogo setImageWithURL:[homeTeam imageURLWithSize:homeTeam.logoUrl andSize:@"120x120"]];
  self.homeTeamScore.text = self.game.homeScoreString;
  self.homeTeamWinner.hidden = ![self.game.winningTeam isEqual:homeTeam];
  self.homeTeamScore.text = self.game.homeScoreString;

  Team *awayTeam = self.game.awayTeam;
  [self.awayTeamLogo setImageWithURL:[awayTeam imageURLWithSize:awayTeam.logoUrl andSize:@"120x120"]];
  self.awayTeamWinner.hidden = ![self.game.winningTeam isEqual:awayTeam];
  self.awayTeamScore.text = self.game.awayScoreString;

  if (self.game.isPregame) {
    // Winner Image
    self.awayTeamWinner.hidden = YES;
    self.homeTeamWinner.hidden = YES;

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
    // Winner Image
    self.awayTeamWinner.hidden = YES;
    self.homeTeamWinner.hidden = YES;

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

  // Header
  CSStickyHeaderFlowLayout *layout = (id)self.collectionView.collectionViewLayout;
  layout.parallaxHeaderReferenceSize = CGSizeMake(self.view.bounds.size.width, headerSize);
  layout.parallaxHeaderMinimumReferenceSize = CGSizeMake(self.view.bounds.size.width, headerSize);
  layout.itemSize = CGSizeMake(self.view.bounds.size.width, layout.itemSize.height);

  // Blur
  self.blurView.frame = self.background.frame;
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch {
  if ([touch.view isEqual:self.view]) {
    return YES;
  }
  else {
    return NO;
  }
}

- (void)backgroundTapped:(UITapGestureRecognizer*)recognizer {
  [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)didRequestClose:(id)sender {
  [self dismissViewControllerAnimated:YES completion:nil];
}

-(void)dismissViewControllerAnimated:(BOOL)flag completion:(void (^)(void))completion {
  [super dismissViewControllerAnimated:flag completion:^{
    [self.delegate dismissedScoreShowViewModal];
  }];
}

#pragma mark 

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
  return 3;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
  return 1;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
  if (indexPath.section == scoreSummaryViewLocation) {
    ScoreSummaryCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:scoreSummaryViewCell forIndexPath:indexPath];
    cell.scoreSummary = self.game.boxscore.scoreSummary;

    return cell;
  }
  else if (indexPath.section == scoreRecapViewLocation) {
    RecapCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:scoreRecapCollectionViewCell forIndexPath:indexPath];
    cell.recap = self.game.boxscore.recap;

    return cell;
  }
  else if (indexPath.section == scoreDetailViewLocation){
    ScoreDetailCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:scoreDetailCollectionViewCell forIndexPath:indexPath];
    cell.game = self.game;
    cell.scoreDetails = self.game.boxscore.scoreDetail;

    return cell;
  }

  return nil;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
  NSLog(@"ROW CLICKED!");

  return;
}

-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
  if (indexPath.section == scoreSummaryViewLocation) {
    return [ScoreSummaryCollectionViewCell measureCellSizeWithResource:self.game.boxscore.scoreSummary andWidth:self.view.bounds.size.width];
  }
  else if (indexPath.section == scoreRecapViewLocation) {
    return [RecapCollectionViewCell measureCellSizeWithResource:self.game.boxscore.recap andWidth:self.view.bounds.size.width];
  }
  else if (indexPath.section == scoreDetailViewLocation) {
    return [ScoreDetailCollectionViewCell measureCellSizeWithResource:self.game.boxscore.scoreDetail andWidth:self.view.bounds.size.width];
  }
  else {
    return CGSizeZero;
  }
}

@end