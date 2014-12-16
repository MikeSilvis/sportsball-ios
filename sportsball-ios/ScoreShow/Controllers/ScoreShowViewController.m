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

@implementation ScoreShowViewController

static NSString * const headerViewCell = @"headerViewCell";
static NSString * const scoreSummaryViewCell = @"scoreSummaryViewCell";
static NSString * const scoreDetailCollectionViewCell = @"scoreDetailCollectionViewCell";

- (void)viewDidLoad {
  [super viewDidLoad];
  self.view.backgroundColor = [UIColor clearColor];

  self.collectionView.alpha = 0.98f;
  self.collectionView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"background"]];

  UITapGestureRecognizer *backgroundRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(backgroundTapped:)];
  backgroundRecognizer.delegate = self;
  [self.view addGestureRecognizer:backgroundRecognizer];

  [self.collectionView registerNib:[UINib nibWithNibName:@"ScoreSummaryViewCell" bundle:nil]
        forCellWithReuseIdentifier:scoreSummaryViewCell];

  [self.collectionView registerNib:[UINib nibWithNibName:@"ScoreDetailCollectionViewCell" bundle:nil]
        forCellWithReuseIdentifier:scoreDetailCollectionViewCell];

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
  CGFloat headerSize = 74;
  CSStickyHeaderFlowLayout *layout = (id)self.collectionView.collectionViewLayout;
  layout.parallaxHeaderReferenceSize = CGSizeMake(self.view.bounds.size.width, headerSize);
  layout.parallaxHeaderMinimumReferenceSize = CGSizeMake(self.view.bounds.size.width, headerSize);
  layout.itemSize = CGSizeMake(self.view.bounds.size.width, layout.itemSize.height);
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch {
  if ([touch.view isEqual:self.collectionView]) {
    return NO;
  }
  else {
    return YES;
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
  return 2;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
  if ((section == 0) || (section == 1)) {
    return 1;
  } else {
    return 0;
  }
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
  if (indexPath.section == 0) {
    ScoreSummaryCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:scoreSummaryViewCell forIndexPath:indexPath];
    cell.scoreSummary = self.game.boxscore.scoreSummary;

    return cell;
  }
  else if (indexPath.section == 1){
    ScoreDetailCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:scoreDetailCollectionViewCell forIndexPath:indexPath];
    cell.game = self.game;
    cell.scoreDetails = self.game.boxscore.scoreDetail;

    return cell;
  }

  return nil;
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
  if (indexPath.section == 0) {
    return [ScoreSummaryCollectionViewCell measureCellSizeWithResource:self.game.boxscore.scoreSummary andWidth:self.view.bounds.size.width];
  }
  else if (indexPath.section == 1) {
    return [ScoreDetailCollectionViewCell measureCellSizeWithResource:self.game.boxscore.scoreDetail andWidth:self.view.bounds.size.width];
  }
  else {
    return CGSizeZero;
  }
}

//-(void)scrollViewDidScroll:(UIScrollView *)scrollView {
//  NSLog(@"scrollView: %f", scrollView.contentOffset.y);

  // Dynamically increase the view size
//  CGRect f = self.collectionView.frame;
//  f.size.height = f.size.height + scrollView.contentOffset.y;
//  f.origin.y = f.origin.y - scrollView.contentOffset.y;
//  if (f.size.height <= self.view.bounds.size.height) {
//    self.collectionView.frame = f;
//  }
//}

@end
