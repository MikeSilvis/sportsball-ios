//
//  ScoreIndexView.m
//  sportsball-ios
//
//  Created by Mike Silvis on 11/6/14.
//  Copyright (c) 2014 Mike Silvis. All rights reserved.
//

#import "ScoreIndexView.h"

@implementation ScoreIndexView

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
  return 3;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
  UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"gameViewCell" forIndexPath:indexPath];
//  Game *currentGame = self.games[indexPath.row];
//  cell.currentGame = currentGame;

  return cell;
}

@end
