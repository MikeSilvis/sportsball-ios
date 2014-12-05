//
//  ScoreDetailCollectionViewCell.h
//  sportsball-ios
//
//  Created by Mike Silvis on 12/4/14.
//  Copyright (c) 2014 Mike Silvis. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ScoreDetailCollectionViewCell : UICollectionViewCell <UICollectionViewDelegate, UICollectionViewDataSource>

@property (nonatomic, strong) NSArray *scoreDetail;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;

+(CGSize)measureCellSizeWithResource:(NSArray *)resource andWidth:(CGFloat)width;

@end
