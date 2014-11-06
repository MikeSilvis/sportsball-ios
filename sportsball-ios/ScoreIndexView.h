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

//#define SERVER_URL @"http://localhost:3000/api/scores/nhl"
#define SERVER_URL @"http://sportsball.herokuapp.com/api/scores/nhl"

@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;

@property (nonatomic, retain) League *league;
@property (nonatomic, strong) UINib *headerNib;
@property (nonatomic, retain) NSMutableArray *games;
@property (nonatomic, retain) NSTimer *scorePuller;

-(void)findGames:(BOOL)showLoader;

@end
