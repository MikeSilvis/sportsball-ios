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
#import "ScoreShowHeader.h"
#import "ScoreSummaryCollectionViewCell.h"
#import "ScoreDetailCollectionViewCell.h"
#import "RecapCollectionViewCell.h"

@implementation ScoreShowViewController

static NSString * const headerViewCell = @"headerViewCell";
static NSString * const scoreSummaryViewCell = @"scoreSummaryViewCell";
static NSString * const scoreDetailCollectionViewCell = @"scoreDetailCollectionViewCell";
static NSString * const scoreRecapCollectionViewCell = @"scoreRecapCollectionViewCell";

static NSString * const WebViewSegue = @"webViewSegue";

static const NSInteger scoreSummaryViewLocation = 0;
static const NSInteger scoreRecapViewLocation   = 1;
static const NSInteger scoreDetailViewLocation  = 2;

static int headerSize = 74;

- (void)viewDidLoad {
  [super viewDidLoad];
  self.view.backgroundColor = [UIColor clearColor];

  // Collection View Styles
  self.collectionView.backgroundColor = [UIColor clearColor];
  self.collectionView.indicatorStyle = UIScrollViewIndicatorStyleWhite;
  self.collectionView.scrollIndicatorInsets = UIEdgeInsetsMake(headerSize, 0, 0, 0);

  // Blur effect
  UIBlurEffect *blur = [UIBlurEffect effectWithStyle:UIBlurEffectStyleDark];
  self.blurView = [[UIVisualEffectView alloc] initWithEffect:blur];
  [self.view insertSubview:self.blurView belowSubview:self.collectionView];

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

  [self.collectionView registerNib:[UINib nibWithNibName:@"ScoreShowHeader" bundle:nil]
        forSupplementaryViewOfKind:CSStickyHeaderParallaxHeader
               withReuseIdentifier:headerViewCell];

  CSStickyHeaderFlowLayout *layout = (id)self.collectionView.collectionViewLayout;
  if ([layout isKindOfClass:[CSStickyHeaderFlowLayout class]]) {
      layout.parallaxHeaderAlwaysOnTop = YES;
      layout.disableStickyHeaders = YES;
  }
}

-(void)viewWillAppear:(BOOL)animated {
  [super viewWillAppear:animated];

  [self.game findBoxscore:nil success:^(Boxscore *boxscore) {
    self.game.boxscore = boxscore;

    [self.collectionView reloadData];
  } failure:nil];
}

-(void)setGame:(Game *)game {
  _game = game;

  [self.collectionView reloadData];
}

-(void)viewWillLayoutSubviews {
  [super viewWillLayoutSubviews];

  // Header
  CSStickyHeaderFlowLayout *layout = (id)self.collectionView.collectionViewLayout;
  layout.parallaxHeaderReferenceSize = CGSizeMake(self.view.bounds.size.width, headerSize);
  layout.parallaxHeaderMinimumReferenceSize = CGSizeMake(self.view.bounds.size.width, headerSize);
  layout.itemSize = CGSizeMake(self.view.bounds.size.width, layout.itemSize.height);

  // Blur
  self.blurView.frame = self.collectionView.frame;
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

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
  if ([kind isEqualToString:CSStickyHeaderParallaxHeader]) {
    ScoreShowHeader *cell = [collectionView dequeueReusableSupplementaryViewOfKind:kind
                                                                        withReuseIdentifier:headerViewCell
                                                                               forIndexPath:indexPath];
    cell.game = self.game;
    return cell;
  }

  return nil;
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