//
//  LeagueViewController.m
//  sportsball-ios
//
//  Created by Mike Silvis on 11/6/14.
//  Copyright (c) 2014 Mike Silvis. All rights reserved.
//

#import "SBLeagueViewController.h"
#import "UIImage+FontAwesome.h"
#import "SBUser.h"
#import "SBLeagueHeader.h"
#import "SBTabViewViewController.h"
#import "SBTransitionAnimator.h"
#import "SBConstants.h"
#import <Mixpanel.h>
#import <ReactiveCocoa.h>

@interface SBLeagueViewController ()

@property (nonatomic, strong) ZFModalTransitionAnimator *modalAnimator;
@property (nonatomic, strong) SBTransitionAnimator *sbAnimator;
@property (nonatomic, copy) NSArray *leagues;

@end

@implementation SBLeagueViewController

static NSString *kTabViewControllerSegue = @"tabViewController";
static NSString * const kLeagueHeaderCell = @"HeaderViewCell";

- (void)viewDidLoad {
  [super viewDidLoad];

  [self buildHelpIcon];

  [self.collectionView registerNib:[UINib nibWithNibName:@"SBLeagueHeader" bundle:nil]
        forCellWithReuseIdentifier:kLeagueHeaderCell];
  self.collectionView.indicatorStyle = UIScrollViewIndicatorStyleWhite;
  self.collectionView.backgroundColor = [UIColor clearColor];

  self.supportButton.hidden = YES;
  [self declareBindings];
  [self findLeagues];
}

- (void)declareBindings {
  @weakify(self);

  [[RACObserve([SBUser currentUser], lastOpenedLeagueIndex) filter:^BOOL(NSNumber *index) {
    return [index isEqual:@(-1)];
  }] subscribeNext:^(id x) {
    @strongify(self);
    self.leagues = [SBUser currentUser].leagues;
    [self.collectionView reloadData];
  }];

  [[[RACObserve([SBUser currentUser], leagues) distinctUntilChanged] filter:^BOOL(SBLeague *league) {
    return [[SBUser currentUser].lastOpenedLeagueIndex isEqual:@(-1)];
  }] subscribeNext:^(NSArray *leagues) {
    @strongify(self);

    NSUInteger previouslyEnabledLeagues = [[self.leagues.rac_sequence filter:^BOOL(SBLeague *league) {
      return [league.enabled boolValue];
    }].array count];

    NSUInteger nowEnabledLeagues = [[leagues.rac_sequence filter:^BOOL(SBLeague *league) {
      return [league.enabled boolValue];
    }].array count];

    if (previouslyEnabledLeagues != nowEnabledLeagues) {
      self.leagues = leagues;
      [self.collectionView reloadData];
      return;
    }

    if ([self.leagues count] != [leagues count]) {
      self.leagues = leagues;
      [self.collectionView reloadData];
      return;
    }
  }];

  [[[RACObserve([SBUser currentUser], lastOpenedLeagueIndex) distinctUntilChanged] filter:^BOOL(NSNumber *lastOpenedLeagueIndex) {
    return [lastOpenedLeagueIndex isEqual: @(-1)];
  }] subscribeNext:^(id x) {
    @strongify(self);
    [self.collectionView reloadData];
    self.supportButton.hidden = NO;
  }];

  [self.activityIndicator rac_liftSelector:@selector(setHidden:) withSignals:[RACObserve([SBUser currentUser], leagues) map:^NSNumber *(NSArray *leagues) {
    return @([leagues count] > 0);
  }], nil];

  [self.supportButton rac_liftSelector:@selector(setHidden:) withSignals:[RACObserve([SBUser currentUser], leagues) map:^NSNumber *(NSArray *leagues) {
    return @([leagues count] == 0);
  }], nil];
}

- (void)findLeagues {
  [SBLeague getSupportedLeagues:nil failure:^(NSError *error) {
    [self showNetworkError:error];
  }];
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

  if ((openedIndex >= 0) && ([SBUser currentUser].enabledLeagues[openedIndex])) {
    [self selectItemAtIndexPath:[NSIndexPath indexPathForItem:openedIndex inSection:0] animated:NO];
  }
}

- (void)selectItemAtIndexPath:(NSIndexPath *)indexPath animated:(BOOL)animated {
  SBLeague *selectedLeague = [SBUser currentUser].leagues[indexPath.row];
  if (![selectedLeague isEnabled]) {
    [[Mixpanel sharedInstance] track:@"selectedDisabledLeague" properties:@{@"league":selectedLeague.name}];
    return;
  }

  [[Mixpanel sharedInstance] track:@"selectedLeague" properties:@{@"league":selectedLeague.name}];

  [SBUser currentUser].lastOpenedLeagueIndex = @(indexPath.row);
  self.selectedIndexPath = indexPath;

  [self performSegueWithIdentifier:kTabViewControllerSegue sender:self];
}

#pragma mark - Collection View

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
  SBLeagueHeader *cell = [self.collectionView dequeueReusableCellWithReuseIdentifier:kLeagueHeaderCell forIndexPath:indexPath];
  cell.league = self.leagues[indexPath.row];

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