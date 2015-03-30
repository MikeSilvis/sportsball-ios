//
//  SBPagingViewController.m
//  sportsball-ios
//
//  Created by Mike Silvis on 3/28/15.
//  Copyright (c) 2015 Mike Silvis. All rights reserved.
//

#import "SBPagingViewController.h"
#import "SBUser.h"
#import "SBStandingsViewCell.h"
#import "SBConstants.h"

@interface SBPagingViewController ()

@property (nonatomic, strong) NSArray *leagues;

@end

@implementation SBPagingViewController

- (void)viewDidLoad {
  [super viewDidLoad];

  [self.delegate defineCells:self.collectionView];

  self.collectionView.backgroundColor = [UIColor clearColor];

  [self buildHamburgerButton];
  [self buildToolBar];
  [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(hideMenuIems:)
                                                 name:kNotificationHideEvent object:nil];
}

- (void)hideMenuIems:(NSNotification *)notification {
  bool alphaHidden = [(NSNumber *)notification.object[@"alpha"] boolValue];

  self.toolBar.hidden = alphaHidden;
}

- (void)viewDidAppear:(BOOL)animated {
  [super viewDidAppear:animated];

  self.leagues = [SBUser currentUser].leagues;
}

- (void)viewDidDisappear:(BOOL)animated {
  [super viewDidDisappear:animated];

  [self.collectionView.visibleCells firstObject];
}

- (void)buildHamburgerButton {
  CGFloat iconSize = 25;
  FAKFontAwesome *hamburgerIcon = [FAKFontAwesome barsIconWithSize:iconSize];
  self.hamburgerButton.image = [UIImage imageWithFontAwesomeIcon:hamburgerIcon andSize:iconSize andColor:@"#fff"];
}

- (void)buildToolBar {
  self.toolBar.backgroundColor = [UIColor clearColor];
  [self.toolBar setBackgroundImage:[UIImage new]
                forToolbarPosition:UIToolbarPositionAny
                        barMetrics:UIBarMetricsDefault];
  self.toolBar.clipsToBounds = YES;
}


- (void)setLeagues:(NSArray *)leagues {
  _leagues = leagues;

  self.pageControl.numberOfPages = [self.leagues count];
  self.pageControl.currentPage = [[SBUser currentUser].lastOpenedLeagueIndex intValue];
  [self.collectionView reloadData];
}

- (void)viewDidLayoutSubviews {
  [super viewDidLayoutSubviews];

  [self.delegate cellDidAppear:[self.collectionView.visibleCells firstObject]];

  if (self.pageControl.currentPage > 0) {
    [self.collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:self.pageControl.currentPage inSection:0]
                                atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally
                                        animated:NO];
  }
}

#pragma mark - Collection View

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
  return [self.leagues count];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
  return [self.delegate collectionView:collectionView cellForItemAtIndexPath:indexPath];
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
  return self.collectionView.frame.size;
}

- (UIEdgeInsets)collectionView:(UICollectionView*)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
  return UIEdgeInsetsMake(0, 0, 0, 0);
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
  float fractionalPage = scrollView.contentOffset.x / scrollView.frame.size.width;
  NSInteger page = lround(fractionalPage);

  self.pageControl.currentPage = page;
  [SBUser currentUser].lastOpenedLeagueIndex = @(self.pageControl.currentPage);
  [self.delegate cellDidAppear:[self.collectionView.visibleCells firstObject]];
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
  return 0;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
  return 0;
}

- (IBAction)hamburgerClicked:(id)sender {
  [self.delegate cellDidDisappear:[self.collectionView.visibleCells firstObject]];

  [SBUser currentUser].lastOpenedLeagueIndex = @(-1);
  
  [self dismissViewControllerAnimated:YES completion:nil];
}

@end
