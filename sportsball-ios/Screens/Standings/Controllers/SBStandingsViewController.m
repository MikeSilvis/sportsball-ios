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
static CGFloat const kTeamViewCellSize = 40;

- (void)viewDidLoad {
  [super viewDidLoad];

  self.divisionStandings = [NSMutableDictionary dictionary];

  self.view.backgroundColor = [UIColor purpleColor];
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
  [self findDivisionStandings];
}

- (void)findDivisionStandings {
  [self.league getStandings:^(NSDictionary *divisionStandings) {
    self.divisionStandings = divisionStandings;
  } failure:^(NSError *error) {
    NSLog(@"Standings error %@", error);
  }];
}

- (void)setLeague:(SBLeague *)league {
  _league = league;

  self.divisionStandings = @{};
}

- (void)setDivisionStandings:(NSDictionary *)divisionStandings {
  _divisionStandings = divisionStandings;

  [self.collectionView reloadData];
}

#pragma mark - CollectionView

- (void)viewWillLayoutSubviews {
  [super viewWillLayoutSubviews];

  CSStickyHeaderFlowLayout *layout = (id)self.collectionView.collectionViewLayout;
  layout.parallaxHeaderReferenceSize = CGSizeMake(self.view.bounds.size.width, kHeaderSize);
  layout.parallaxHeaderMinimumReferenceSize = CGSizeMake(self.view.bounds.size.width, kHeaderSize);
  layout.itemSize = CGSizeMake(self.collectionView.frame.size.width, layout.itemSize.height);
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
  if ([self.divisionStandings count] == 0) {
    return 0;
  }

  NSString *divisionKey = [self.divisionStandings allKeys][section];

  return [self.divisionStandings[divisionKey] count];
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
  return [self.divisionStandings count];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
  NSString *divisionKey = [self.divisionStandings allKeys][indexPath.section];
  SBTeam *currentTeam = self.divisionStandings[divisionKey][indexPath.row];

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

    cell.divisionLabel.text = [self.divisionStandings allKeys][indexPath.section];
    return cell;
  }

  return nil;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section {
  return CGSizeMake(self.view.bounds.size.width, kHeaderStandingsCellSize);
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
  return CGSizeMake(self.collectionView.bounds.size.width, kTeamViewCellSize);
}

@end
