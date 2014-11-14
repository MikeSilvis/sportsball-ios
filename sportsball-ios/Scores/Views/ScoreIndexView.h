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

@protocol ScoreIndexViewDelegate <NSObject>

-(void)didStartLoading;
-(void)didEndLoading;

@end

@interface ScoreIndexView : UIView <UICollectionViewDataSource, UICollectionViewDelegate>

@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;

@property (nonatomic, retain) League *league;
@property (nonatomic, strong) UINib *headerNib;
@property (nonatomic, retain) NSArray *games;
@property (nonatomic, retain) NSTimer *scorePuller;
@property (weak, nonatomic) IBOutlet DIDatepicker *datePicker;
@property (nonatomic, retain) NSDate *currentDate;

@property (nonatomic, weak) id<ScoreIndexViewDelegate> delegate;

-(void)findGames;
-(void)cancelTimer;
-(void)startTimer;

@end
