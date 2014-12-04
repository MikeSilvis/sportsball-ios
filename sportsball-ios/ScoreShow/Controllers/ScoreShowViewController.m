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

@implementation ScoreShowViewController

static NSString * const gameViewCell = @"gameViewCell";
static NSString * const headerViewCell = @"headerViewCell";
static NSString * const scoreSummaryViewCell = @"scoreSummaryViewCell";

- (void)viewDidLoad {
  [super viewDidLoad];
  self.view.backgroundColor = [UIColor clearColor];

  UITapGestureRecognizer *backgroundRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(backgroundTapped:)];
  backgroundRecognizer.delegate = self;
  [self.view addGestureRecognizer:backgroundRecognizer];

  [self.collectionView registerNib:[UINib nibWithNibName:@"ScoreSummaryViewCell" bundle:nil] forCellWithReuseIdentifier:scoreSummaryViewCell];
  [self.collectionView registerNib:[UINib nibWithNibName:@"ScoreShowHeader" bundle:nil] forSupplementaryViewOfKind:CSStickyHeaderParallaxHeader withReuseIdentifier:headerViewCell];

  CSStickyHeaderFlowLayout *layout = (id)self.collectionView.collectionViewLayout;
  if ([layout isKindOfClass:[CSStickyHeaderFlowLayout class]]) {
      layout.parallaxHeaderAlwaysOnTop = YES;
      layout.disableStickyHeaders = YES;
  }
}

-(void)viewWillAppear:(BOOL)animated {
  [super viewWillAppear:animated];

  // Set the collection view to be half the size of the frame
  CGRect f = self.collectionView.frame;
  f.size.height = self.view.bounds.size.height / 2;
  self.collectionView.frame = f;

//  [self.game findBoxscore:nil success:^(Boxscore *boxscore) {
//    self.boxscore = boxscore;
//    self.game.boxscore = boxscore;
//  } failure:nil];
}

-(void)setGame:(Game *)game {
  _game = game;
  Boxscore *boxscore = [[Boxscore alloc] init];
  boxscore.scoreSummary = @[
                            @[@"", @"1", @"2", @"3", @"T"],
                            @[@"CGY", @"0", @"3", @"3", @"6"],
                            @[@"FLA", @"1", @"3", @"0", @"4"]
                            ];
  _game.boxscore = boxscore;

  [self.collectionView reloadData];
}

-(void)viewWillLayoutSubviews {
  [super viewWillLayoutSubviews];

  // Header
  CGFloat headerSize = 74;
  CSStickyHeaderFlowLayout *layout = (id)self.collectionView.collectionViewLayout;
  layout.parallaxHeaderReferenceSize = CGSizeMake(self.view.bounds.size.width, headerSize);
  layout.parallaxHeaderMinimumReferenceSize = CGSizeMake(self.view.bounds.size.width, headerSize);
  layout.itemSize = CGSizeMake(self.view.frame.size.width, layout.itemSize.height);
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
  return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
  if (section == 0) {
    return 1;
  } else {
    return 0;
  }
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
  ScoreSummaryCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:scoreSummaryViewCell forIndexPath:indexPath];
  cell.scoreSummary = self.game.boxscore.scoreSummary;

  return cell;
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
  else {
    return CGSizeZero;
  }
}

//- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section {
//  if (section == 0) {
//    return CGSizeMake(self.view.bounds.size.width, 200);
//  } else {
//    return CGSizeZero;
//  }
//}

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
