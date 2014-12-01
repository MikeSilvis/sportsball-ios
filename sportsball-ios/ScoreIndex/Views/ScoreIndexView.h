//
//  ScoreIndexView.h
//  sportsball-ios
//
//  Created by Mike Silvis on 11/6/14.
//  Copyright (c) 2014 Mike Silvis. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "League.h"
#import "DIDatepicker.h"
#import "Game.h"

@protocol ScoreIndexViewDelegate <NSObject>

-(void)didStartLoading;
-(void)didEndLoading;
-(void)selectedGame:(Game *)game;

@end

@interface ScoreIndexView : UIView <UICollectionViewDataSource, UICollectionViewDelegate>

@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;

@property (nonatomic, strong) League *league;
@property (nonatomic, strong) UINib *headerNib;
@property (nonatomic, strong) NSArray *games;
@property (nonatomic, strong) NSTimer *scorePuller;
@property (weak, nonatomic) IBOutlet DIDatepicker *datePicker;
@property (nonatomic, strong) NSDate *currentDate;

@property (nonatomic, weak) id<ScoreIndexViewDelegate> delegate;

-(void)findGames;
-(void)cancelTimer;
-(void)startTimer;

@end
