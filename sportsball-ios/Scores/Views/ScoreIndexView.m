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

  CSStickyHeaderFlowLayout *layout = (id)self.collectionView.collectionViewLayout;
  if ([layout isKindOfClass:[CSStickyHeaderFlowLayout class]]) {
      layout.parallaxHeaderAlwaysOnTop = YES;
      layout.disableStickyHeaders = YES;
  }
}

-(void)cancelTimer {
  NSLog(@"Stopping Timer: %@", self.league.name);

  [self.scorePuller invalidate];
  self.scorePuller = nil;
}

-(void)startTimer {
  if (!self.scorePuller) {
    NSLog(@"Starting Timer: %@", self.league.name);

    [self findGames];
    self.scorePuller = [NSTimer scheduledTimerWithTimeInterval:90 target:self selector:@selector(findGames) userInfo:nil repeats:YES];
  }
}

-(void)findGames {
  if (self.games.count == 0) {
    [self.delegate didStartLoading];
  }

  [self.league allScoresForDate:nil parameters:nil success:^(NSArray *games) {
    self.games = games;
    [self.collectionView reloadData];
    [self.delegate didEndLoading];
  } failure:^(NSError *error) {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle: @"Sorry :("
                                                    message: @"Something happened, and the data failed to load."
                                                   delegate: nil
                                          cancelButtonTitle:@"OK"
                                          otherButtonTitles:nil];
    if (self.games.count == 0) {
      [alert show];
    }
    [self.delegate didEndLoading];
  }];
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

-(void)layoutSubviews {
  [super layoutSubviews];

  CGFloat headerSize = 74;
  CSStickyHeaderFlowLayout *layout = (id)self.collectionView.collectionViewLayout;
  layout.parallaxHeaderReferenceSize = CGSizeMake(self.bounds.size.width, headerSize);
  layout.parallaxHeaderMinimumReferenceSize = CGSizeMake(self.bounds.size.width, headerSize);
  layout.itemSize = CGSizeMake(self.frame.size.width, layout.itemSize.height);
}

@end
