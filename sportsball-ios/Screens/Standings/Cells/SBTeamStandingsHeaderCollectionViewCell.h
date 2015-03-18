//
//  SBTeamStandingsHeaderCollectionViewCell.h
//  sportsball-ios
//
//  Created by Mike Silvis on 3/17/15.
//  Copyright (c) 2015 Mike Silvis. All rights reserved.
//

#import "SBStanding.h"
#import <UIKit/UIKit.h>

@interface SBTeamStandingsHeaderCollectionViewCell : UICollectionViewCell <UICollectionViewDataSource, UICollectionViewDelegate>

@property (nonatomic, strong) SBStanding *standing;
@property (nonatomic, strong) NSIndexPath *indexPath;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;

@end
