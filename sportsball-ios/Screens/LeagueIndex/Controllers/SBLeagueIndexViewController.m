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
#import "SBLeagueHeader.h"
#import "SBTabViewViewController.h"
#import "SBTransitionAnimator.h"

@interface SBLeagueIndexViewController ()

@property (nonatomic, strong) ZFModalTransitionAnimator *modalAnimator;
@property (nonatomic, strong) SBTransitionAnimator *sbAnimator;
@property (nonatomic, copy) NSArray *leagues;

@end

@implementation SBLeagueIndexViewController

static NSString *kTabViewControllerSegue = @"tabViewController";
static NSString * const kLeagueHeaderCell = @"HeaderViewCell";
static CGFloat const kHeaderSize = 100;

- (void)viewDidLoad {
  [super viewDidLoad];

  self.leagues = [SBUser currentUser].leagues;

  [self buildHelpIcon];

  [self.collectionView registerNib:[UINib nibWithNibName:@"SBLeagueHeader" bundle:nil]
        forCellWithReuseIdentifier:kLeagueHeaderCell];
  self.collectionView.indicatorStyle = UIScrollViewIndicatorStyleWhite;
  self.collectionView.backgroundColor = [UIColor clearColor];
}

- (void)viewDidAppear:(BOOL)animated {
  [super viewDidAppear:animated];

  [self openAtLastSelectedIndex];
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

  if ((openedIndex >= 0) && (self.leagues[openedIndex])) {
    [self selectItemAtIndexPath:[NSIndexPath indexPathForItem:openedIndex inSection:0] animated:NO];
  }
}

- (void)selectItemAtIndexPath:(NSIndexPath *)indexPath animated:(BOOL)animated {
  [SBUser currentUser].lastOpenedLeagueIndex = @(indexPath.row);
  self.selectedIndexPath = indexPath;

  [self performSegueWithIdentifier:kTabViewControllerSegue sender:self];
}

#pragma mark - Collection View

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
  SBLeagueHeader *cell = [self.collectionView dequeueReusableCellWithReuseIdentifier:kLeagueHeaderCell forIndexPath:indexPath];
  cell.currentLeague = self.leagues[indexPath.row];

  return cell;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
  return [self.leagues count];
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
  [self selectItemAtIndexPath:indexPath animated:YES];
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
  return CGSizeMake(self.view.bounds.size.width, kHeaderSize);
}

- (UIEdgeInsets)collectionView:(UICollectionView*)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
  return UIEdgeInsetsMake(0, 0, 0, 0);
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
  return 0;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
  return 0;
}


#pragma mark - Segue

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
  if ([segue.identifier isEqualToString:kTabViewControllerSegue]) {
    SBTabViewViewController *destinationViewController = segue.destinationViewController;
    self.sbAnimator = [[SBTransitionAnimator alloc] init];

    destinationViewController.league = [SBUser currentUser].lastOpenedLeague;
    destinationViewController.modalPresentationStyle = UIModalPresentationCustom;
    destinationViewController.transitioningDelegate = self.sbAnimator;
  }
  else {
    SBModalViewController *destinationViewController = segue.destinationViewController;
    self.modalAnimator = [[ZFModalTransitionAnimator alloc] initWithModalViewController:destinationViewController];
    self.modalAnimator.dragable = YES;
    self.modalAnimator.direction = ZFModalTransitonDirectionBottom|ZFModalTransitonDirectionTop;

    // set transition delegate of modal view controller to our object
    destinationViewController.transitioningDelegate = self.modalAnimator;
    destinationViewController.modalPresentationStyle = UIModalPresentationCustom;
  }
}

@end
