//
//  ScoreIndexView.m
//  sportsball-ios
//
//  Created by Mike Silvis on 11/6/14.
//  Copyright (c) 2014 Mike Silvis. All rights reserved.
//

#import "ScoreIndexView.h"
#import "GameCollectionViewCell.h"
#import "LeagueHeader.h"
#import "CSStickyHeaderFlowLayout.h"
#import "UIImage+Blur.h"
#import "UIImage+FontAwesome.h"

@implementation ScoreIndexView

static NSString * const gameViewCell = @"gameViewCell";
static NSString * const headerViewCell = @"headerViewCell";

-(void)awakeFromNib {
  self.games = [NSMutableArray array];

  self.backgroundColor = [UIColor clearColor];
  self.collectionView.backgroundColor = [UIColor clearColor];

  [self.collectionView registerNib:[UINib nibWithNibName:@"GameCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:gameViewCell];
  [self.collectionView registerNib:[UINib nibWithNibName:@"LeagueHeader" bundle:nil] forSupplementaryViewOfKind:CSStickyHeaderParallaxHeader withReuseIdentifier:headerViewCell];

  CGFloat iconSize = 30;
  FAKFontAwesome *hamburgerIcon = [FAKFontAwesome barsIconWithSize:iconSize];
  self.leagueBarButton.image = [UIImage imageWithFontAwesomeIcon:hamburgerIcon andSize:iconSize andColor:@"#c4eefe"];
}

-(void)cancelTimer {
  NSLog(@"Stopping Timer: %@", self.league.name);

  [self.scorePuller invalidate];
  self.scorePuller = nil;
}

-(void)startTimer {
  if (!self.scorePuller) {
    NSLog(@"Starting Timer: %@", self.league.name);

    [self findGames:YES];
    self.scorePuller = [NSTimer scheduledTimerWithTimeInterval:30 target:self selector:@selector(findGames:) userInfo:nil repeats:YES];
  }
}

- (IBAction)leagueBarButtonClicked:(id)sender {
  [self.delegate didRequestClose];
}

-(void)findGames:(BOOL)showLoader {
  [self.league allScoresForDate:nil parameters:nil success:^(NSArray *games) {
    self.games = games;
    [self.collectionView reloadData];
  } failure:nil];
}

-(void)setLeague:(League *)league {
  _league = league;

  [self setupParallax];
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
  NSLog(@"clicked!");
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
  return self.games.count;
}

-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
  return CGSizeMake(self.bounds.size.width, 60);
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
  Game *currentGame = self.games[indexPath.row];
  GameCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:gameViewCell forIndexPath:indexPath];
  cell.currentGame = currentGame;


  return cell;
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
  if ([kind isEqualToString:CSStickyHeaderParallaxHeader]) {
    LeagueHeader *cell = [collectionView dequeueReusableSupplementaryViewOfKind:kind
                                                                        withReuseIdentifier:headerViewCell
                                                                               forIndexPath:indexPath];
    cell.currentLeague = self.league;

    return cell;
  } //else if ([kind isEqualToString:UICollectionElementKindSectionHeader]) {
      // Your code to configure your section header...
//  }

  return nil;
}

- (void)setupParallax
{
    CSStickyHeaderFlowLayout *layout = (id)self.collectionView.collectionViewLayout;
    if ([layout isKindOfClass:[CSStickyHeaderFlowLayout class]]) {
        layout.parallaxHeaderAlwaysOnTop = YES;
        layout.disableStickyHeaders = YES;
    }
}


- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}

-(void)layoutSubviews {
  CGFloat headerSize = 64;
  CSStickyHeaderFlowLayout *layout = (id)self.collectionView.collectionViewLayout;
  layout.parallaxHeaderReferenceSize = CGSizeMake(self.bounds.size.width, headerSize);
  layout.parallaxHeaderMinimumReferenceSize = CGSizeMake(self.bounds.size.width, headerSize);
  layout.itemSize = CGSizeMake(self.frame.size.width, layout.itemSize.height);
}

@end
