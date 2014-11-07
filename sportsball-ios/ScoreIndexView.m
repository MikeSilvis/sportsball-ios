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
#import <AFNetworking/AFHTTPRequestOperationManager.h>

@implementation ScoreIndexView

static NSString * const gameViewCell = @"gameViewCell";
static NSString * const headerViewCell = @"headerViewCell";

-(void)awakeFromNib {
  self.games = [NSMutableArray array];

  [self.collectionView registerNib:[UINib nibWithNibName:@"GameCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:gameViewCell];
  [self.collectionView registerNib:[UINib nibWithNibName:@"LeagueHeader" bundle:nil] forSupplementaryViewOfKind:CSStickyHeaderParallaxHeader withReuseIdentifier:headerViewCell];
}

-(void)cancelTimer {
  NSLog(@"\n Stopping Timer: %@ \n", self.league.name);

  [self.scorePuller invalidate];
  self.scorePuller = nil;
}

-(void)startTimer {
  if (!self.scorePuller) {
    NSLog(@"\n Starting Timer: %@ \n", self.league.name);

    [self findGames:YES];
    self.scorePuller = [NSTimer scheduledTimerWithTimeInterval:30 target:self selector:@selector(findGames:) userInfo:nil repeats:YES];
  }
}

-(void)findGames:(BOOL)showLoader {
  self.games = [NSMutableArray array];

  [self.league allScoresForDate:nil parameters:nil success:^(NSArray *games) {
    self.games = [NSMutableArray arrayWithArray:games];
    [self.collectionView reloadData];
  } failure:nil];
}

-(void)setLeague:(League *)league {
  _league = league;

  [self setupParallax];
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
  return self.games.count;
}

-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
  return CGSizeMake(self.bounds.size.width, 60);
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
  GameCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:gameViewCell forIndexPath:indexPath];
  Game *currentGame = self.games[indexPath.row];
  cell.currentGame = currentGame;

  return cell;
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    LeagueHeader *cell = [collectionView dequeueReusableSupplementaryViewOfKind:kind
                                                                        withReuseIdentifier:headerViewCell
                                                                               forIndexPath:indexPath];
    cell.currentLeague = self.league;

    return cell;
}

- (void)setupParallax
{
    // jpeg quality image data
    float quality = .00001f;

    // intensity of blurred
    float blurred = 20.1f;

    NSData *imageData = UIImageJPEGRepresentation([UIImage imageNamed:self.league.background], quality);
    UIImage *blurredImage = [[UIImage imageWithData:imageData] blurredImage:blurred];
    self.backgroundColor = [UIColor colorWithPatternImage:blurredImage];

    self.collectionView.backgroundColor = [UIColor clearColor];

    CSStickyHeaderFlowLayout *layout = (id)self.collectionView.collectionViewLayout;
    if ([layout isKindOfClass:[CSStickyHeaderFlowLayout class]]) {
        layout.parallaxHeaderAlwaysOnTop = YES;
        layout.disableStickyHeaders = YES;
    }

    // Also insets the scroll indicator so it appears below the search bar
    self.collectionView.scrollIndicatorInsets = UIEdgeInsetsMake(0, 0, 0, 0);
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
