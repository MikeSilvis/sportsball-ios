//
//  ScoreIndex2CollectionViewController.h
//  sportsball-ios
//
//  Created by Mike Silvis on 10/31/14.
//  Copyright (c) 2014 Mike Silvis. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ScoreIndexCollectionViewController : UICollectionViewController

@property (nonatomic, strong) UINib *headerNib;
@property (nonatomic, retain) NSMutableArray *games;
@property (nonatomic, retain) NSTimer *scorePuller;

-(void)findGames:(BOOL)showLoader;

@end
