//
//  ScoreIndexView.m
//  sportsball-ios
//
//  Created by Mike Silvis on 11/6/14.
//  Copyright (c) 2014 Mike Silvis. All rights reserved.
//

#import "ScoreIndexView.h"
#import "GameCollectionViewCell.h"
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

  [self callThisMethod];
}

-(void)findGames:(BOOL)showLoader {
  NSDateFormatter *df = [[NSDateFormatter alloc] init];
  [df setDateFormat:@"yyyy-MM-dd"];
  NSDictionary *params = @{@"date": [df stringFromDate:[NSDate date]]};
  self.games = [NSMutableArray array];

  [[AFHTTPRequestOperationManager manager] GET:self.league.scoresUrl parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
    for (id score in responseObject[@"scores"]) {
        Game *newGame = [[Game alloc] initWithJson:score];
        [self.games addObject:newGame];
    }
    [self.collectionView reloadData];
  } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
    NSLog(@"Error: %@", error);
  }];
}

-(void)setLeague:(League *)league {
  _league = league;
  [self findGames:NO];
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

- (void)callThisMethod
{
    // jpeg quality image data
    float quality = .00001f;

    // intensity of blurred
    float blurred = 1.1f;

    NSData *imageData = UIImageJPEGRepresentation([UIImage imageNamed:@"nhl-background"], quality);
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

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    UICollectionReusableView *cell = [collectionView dequeueReusableSupplementaryViewOfKind:kind
                                                                        withReuseIdentifier:headerViewCell
                                                                               forIndexPath:indexPath];

    return cell;
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}

-(void)layoutSubviews {
    CSStickyHeaderFlowLayout *layout = (id)self.collectionView.collectionViewLayout;
    layout.parallaxHeaderReferenceSize = CGSizeMake(self.bounds.size.width, 200);
    layout.parallaxHeaderMinimumReferenceSize = CGSizeMake(self.bounds.size.width, 64);

    layout.itemSize = CGSizeMake(self.frame.size.width, layout.itemSize.height);
}

@end
