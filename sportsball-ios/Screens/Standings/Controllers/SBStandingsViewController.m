//
//  SBStandingsViewController.m
//  sportsball-ios
//
//  Created by Mike Silvis on 3/10/15.
//  Copyright (c) 2015 Mike Silvis. All rights reserved.
//

#import "SBStandingsViewController.h"
#import "CSStickyHeaderFlowLayout.h"
#import "SBTeamStandingsCollectionViewCell.h"
#import "SBTeamStandingsHeaderCollectionViewCell.h"

@implementation SBStandingsViewController

static NSString * const kTeamViewCell = @"TeamViewCell";
static NSString * const kHeaderViewCell = @"HeaderViewCell";
static NSString * const kHeaderStandingsViewCell = @"HeaderStandingsViewCell";
static CGFloat const kHeaderSize = 74;
static CGFloat const kHeaderStandingsCellSize = 25;
static CGFloat const kTeamViewCellSize = 45;

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

  self.league = [SBUser currentUser].lastOpenedLeague;

  // Stub data hack
  self.standing = [[SBStanding alloc] init];
  self.standing.divisions = @{
                              @"stub": @[[[SBTeam alloc] init]]
                              };

  [self findDivisionStandings];
}

- (void)findDivisionStandings {
  if ([self.standing.headers count] == 0) {
    self.activityIndicator.hidden = NO;
  }

  [self.league getStanding:^(SBStanding *standing) {
    self.standing = standing;
    self.activityIndicator.hidden = YES;
  } failure:^(NSError *error) {
    NSLog(@"Standings error %@", error);
  }];
}

- (void)setLeague:(SBLeague *)league {
  _league = league;

  self.standing = nil;
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

  SBTeamStandingsCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kTeamViewCell forIndexPath:indexPath];
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
