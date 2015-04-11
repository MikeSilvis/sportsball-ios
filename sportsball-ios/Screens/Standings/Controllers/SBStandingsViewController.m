//
//  SBStandingsViewController.m
//  sportsball-ios
//
//  Created by Mike Silvis on 3/28/15.
//  Copyright (c) 2015 Mike Silvis. All rights reserved.
//

#import "SBStandingsViewController.h"
#import "SBUser.h"
#import "SBConstants.h"
#import "SBPagingViewController.h"
#import "CSStickyHeaderFlowLayout.h"
#import "SBTeamStandingsHeaderCollectionViewCell.h"
#import "SBTeamStandingsCollectionViewCell.h"
#import "SBLeagueHeader.h"
#import <MPGNotification.h>

@interface SBStandingsViewController () <SBPagingViewDelegate, UICollectionViewDataSource, UICollectionViewDelegate>

@property (nonatomic, strong) SBStanding *standing;

@end

@implementation SBStandingsViewController

static NSString * const kTeamViewCell = @"TeamViewCell";
static NSString * const kHeaderViewCell = @"HeaderViewCell";
static NSString * const kHeaderStandingsViewCell = @"HeaderStandingsViewCell";
static CGFloat const kHeaderStandingsCellSize = 25;
static CGFloat const kTeamViewCellSize = 45;

static NSString *kPagingSegue = @"pagingSegue";

- (void)viewDidLoad {
  [super viewDidLoad];
  
  self.view.backgroundColor = [UIColor clearColor];
  
  self.collectionView.backgroundColor = [UIColor clearColor];

  // Cells
  [self.collectionView registerNib:[UINib nibWithNibName:@"SBteamStandingsCollectionViewCell" bundle:nil]
        forCellWithReuseIdentifier:kTeamViewCell];
  // Headers
  [self.collectionView registerNib:[UINib nibWithNibName:@"SBLeagueHeader" bundle:nil]
        forSupplementaryViewOfKind:CSStickyHeaderParallaxHeader
               withReuseIdentifier:kHeaderViewCell];
  [self.collectionView registerNib:[UINib nibWithNibName:@"SBTeamStandingsHeaderCollectionViewCell" bundle:nil]
        forSupplementaryViewOfKind:UICollectionElementKindSectionHeader
               withReuseIdentifier:kHeaderStandingsViewCell];

  CSStickyHeaderFlowLayout *layout = (id)self.collectionView.collectionViewLayout;
  if ([layout isKindOfClass:[CSStickyHeaderFlowLayout class]]) {
      layout.parallaxHeaderAlwaysOnTop = YES;
  }

  self.collectionView.indicatorStyle = UIScrollViewIndicatorStyleWhite;
  self.collectionView.scrollIndicatorInsets = UIEdgeInsetsMake(kHeaderSize, 0, 0, 0);
}

- (void)viewDidAppear:(BOOL)animated {
  [super viewDidAppear:animated];
  
  [self.collectionView reloadData];
}

- (UIViewController *)viewControllerAtIndex:(NSUInteger)index {
  SBStandingsViewController *pageContentViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"SBStandingsViewController"];
  pageContentViewController.pageIndex = index;
  pageContentViewController.league = [SBUser currentUser].leagues[index];
  NSLog(@"opening league with name: %@", pageContentViewController.league.name);

  return pageContentViewController;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
  if ([segue.identifier isEqualToString:kPagingSegue]) {
    SBPagingViewController *viewController = segue.destinationViewController;
    viewController.delegate = self;
  }
}

- (void)setLeague:(SBLeague *)league {
  _league = league;
  if (![self.standing.leagueName isEqualToString:self.league.name]) {
    [self stubStanding];
  }
  NSLog(@"league Name: %@", self.league.name);
  
  [self startTimer];
  [self.collectionView reloadData];
  [self viewWillLayoutSubviews];
}

- (void)stubStanding {
  self.standing = nil;
  // Stub data hack
  self.standing = [[SBStanding alloc] init];
  self.standing.divisions = @{
                              @"stub": @[[[SBTeam alloc] init]]
                              };
}

- (void)cancelTimer {
}

- (void)startTimer {
  if ([self.standing.divisions count] == 1) {
    [self findDivisionStandings];
  }
}

- (void)findDivisionStandings {
  self.activityIndicator.hidden = NO;
  [self stubStanding];

  [self.league getStanding:^(SBStanding *standing) {
    self.standing = standing;
    self.activityIndicator.hidden = YES;
  } failure:^(NSError *error) {
    [self showNetworkError:error];
    self.activityIndicator.hidden = YES;
  }];
}

- (void)showNetworkError:(NSError *)error {
  MPGNotification *notification = [MPGNotification notificationWithHostViewController:self
                                                                                title:[[SBUser currentUser] networkConnectionErrorMessage:nil]
                                                                             subtitle:nil
                                                                      backgroundColor:[UIColor colorWithRed:0.910 green:0.278 blue:0.128 alpha:1.000]
                                                                            iconImage:[[SBUser currentUser] networkConnectionErrorIcon]];
  notification.animationType = MPGNotificationAnimationTypeDrop;
  [notification show];
}

- (void)setStanding:(SBStanding *)standing {
  _standing = standing;

  [self.collectionView reloadData];
}

- (void)viewWillLayoutSubviews {
  [super viewWillLayoutSubviews];

  CSStickyHeaderFlowLayout *layout = (id)self.collectionView.collectionViewLayout;
  layout.parallaxHeaderReferenceSize = CGSizeMake(self.collectionView.bounds.size.width, kHeaderSize);
  layout.parallaxHeaderMinimumReferenceSize = CGSizeMake(self.collectionView.bounds.size.width, kHeaderSize);
  layout.itemSize = CGSizeMake(self.collectionView.bounds.size.width, layout.itemSize.height);

  [self.collectionView reloadData];
}


#pragma mark - CollectionView

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
  if ([self.standing.divisions count] == 0) {
    return 0;
  }

  NSString *divisionKey = [self.standing.divisions allKeys][section];

  return [self.standing.divisions[divisionKey] count];
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
  return [self.standing.divisions count];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
  NSString *divisionKey = [self.standing.divisions allKeys][indexPath.section];
  SBTeam *currentTeam = self.standing.divisions[divisionKey][indexPath.row];

  SBTeamStandingsCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kTeamViewCell
                                                                                      forIndexPath:indexPath];
  cell.team = currentTeam;

  return cell;
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
  if ([kind isEqualToString:CSStickyHeaderParallaxHeader]) {
    SBLeagueHeader *cell = [collectionView dequeueReusableSupplementaryViewOfKind:kind
                                                                        withReuseIdentifier:kHeaderViewCell
                                                                               forIndexPath:indexPath];
    cell.currentLeague = self.league;

    return cell;
  }
  else if ([kind isEqualToString:UICollectionElementKindSectionHeader]) {
    SBTeamStandingsHeaderCollectionViewCell *cell = [collectionView dequeueReusableSupplementaryViewOfKind:kind
                                                                              withReuseIdentifier:kHeaderStandingsViewCell
                                                                                     forIndexPath:indexPath];

    cell.indexPath = indexPath;
    cell.standing = self.standing;
    return cell;
  }

  return nil;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section {
  if ([self.standing.headers count] == 0) {
    return CGSizeMake(self.collectionView.bounds.size.width, 0);
  }

  return CGSizeMake(self.collectionView.bounds.size.width, kHeaderStandingsCellSize);
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
  if ([self.standing.headers count] == 0) {
    return CGSizeMake(self.collectionView.bounds.size.width, 0);
  }

  return CGSizeMake(self.collectionView.bounds.size.width, kTeamViewCellSize);
}


@end
