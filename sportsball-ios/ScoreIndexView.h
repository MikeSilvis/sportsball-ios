//
//  ScoreIndexView.h
//  sportsball-ios
//
//  Created by Mike Silvis on 11/6/14.
//  Copyright (c) 2014 Mike Silvis. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "League.h"

@interface ScoreIndexView : UIView <UICollectionViewDataSource, UICollectionViewDelegate>

@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;

@property (nonatomic, retain) League *league;
@property (nonatomic, strong) UINib *headerNib;
@property (nonatomic, retain) NSMutableArray *games;
@property (nonatomic, retain) NSTimer *scorePuller;

-(void)findGames:(BOOL)showLoader;

-(void)cancelTimer;
-(void)startTimer;

@end
