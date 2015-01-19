//
//  ScoreSummaryCollectionViewCell.h
//  sportsball-ios
//
//  Created by Mike Silvis on 12/4/14.
//  Copyright (c) 2014 Mike Silvis. All rights reserved.
//

#import "SportsBallTableViewCell.h"
#import "Game.h"

@interface ScoreSummaryViewCell : SportsBallTableViewCell <UICollectionViewDelegate, UICollectionViewDataSource>

@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (nonatomic, strong) NSArray *scoreSummary;
@property (nonatomic, strong) Game *game;

+(CGSize)measureCellSizeWithResource:(NSArray *)resource andWidth:(CGFloat)width;

@end
