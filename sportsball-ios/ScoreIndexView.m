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

@implementation ScoreIndexView

static NSString * const gameViewCell = @"gameViewCell";

-(void)awakeFromNib {
  self.games = [NSMutableArray array];
  self.headerNib = [UINib nibWithNibName:@"LeagueHeader" bundle:nil];

  [self.collectionView registerNib:[UINib nibWithNibName:@"GameCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:gameViewCell];
  [self callThisMethod];
}

-(void)findGames:(BOOL)showLoader {
  NSLog(@"TODO: IMPLEMENT ME");
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
  return 3;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
  GameCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:gameViewCell forIndexPath:indexPath];
//  Game *currentGame = self.games[indexPath.row];
//  cell.currentGame = currentGame;

  return cell;

}

- (void)callThisMethod
{
    CSStickyHeaderFlowLayout *layout = (id)self.collectionView.collectionViewLayout;

    // jpeg quality image data
    float quality = .00001f;

    // intensity of blurred
    float blurred = 1.1f;

    NSData *imageData = UIImageJPEGRepresentation([UIImage imageNamed:@"nhl-background"], quality);
    UIImage *blurredImage = [[UIImage imageWithData:imageData] blurredImage:blurred];
    self.backgroundColor = [UIColor colorWithPatternImage:blurredImage];

    self.collectionView.backgroundColor = [UIColor clearColor];

    if ([layout isKindOfClass:[CSStickyHeaderFlowLayout class]]) {
        layout.parallaxHeaderReferenceSize = CGSizeMake(self.frame.size.width, 200);
        layout.parallaxHeaderMinimumReferenceSize = CGSizeMake(self.frame.size.width, 64);
        layout.itemSize = CGSizeMake(self.frame.size.width, layout.itemSize.height);
        layout.parallaxHeaderAlwaysOnTop = YES;
        layout.disableStickyHeaders = YES;
    }


    // Also insets the scroll indicator so it appears below the search bar
    self.collectionView.scrollIndicatorInsets = UIEdgeInsetsMake(0, 0, 0, 0);

    [self.collectionView registerNib:self.headerNib
          forSupplementaryViewOfKind:CSStickyHeaderParallaxHeader
                 withReuseIdentifier:@"header"];
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    UICollectionReusableView *cell = [collectionView dequeueReusableSupplementaryViewOfKind:kind
                                                                        withReuseIdentifier:@"header"
                                                                               forIndexPath:indexPath];

    return cell;
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}

@end
