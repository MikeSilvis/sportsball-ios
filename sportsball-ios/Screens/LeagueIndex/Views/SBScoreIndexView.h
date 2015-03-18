//
//  ScoreIndexView.h
//  sportsball-ios
//
//  Created by Mike Silvis on 11/6/14.
//  Copyright (c) 2014 Mike Silvis. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SBLeague.h"
#import "DIDatepicker.h"
#import "SBGame.h"
#import "SBLeagueHeader.h"
#import "SBDatePickerCollectionViewCell.h"

@protocol SBScoreIndexViewDelegate <NSObject>

- (void)selectedGame:(SBGame *)game;
- (void)requestClose;
- (void)requestFailed:(NSError *)error;
- (void)askForFavoriteTeam:(SBTeam *)team;

@end

@interface SBScoreIndexView : UIView <UICollectionViewDataSource, UICollectionViewDelegate, SBDatePickerCollectionViewCellDelegate>

@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;

@property (nonatomic, strong) SBLeague *league;
@property (nonatomic, strong) UINib *headerNib;
@property (nonatomic, strong) NSArray *games;
@property (nonatomic, strong) NSTimer *scorePuller;
@property (nonatomic, strong) NSDate *currentDate;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;

@property (nonatomic, weak) id<SBScoreIndexViewDelegate> delegate;

- (void)findGames;
- (void)cancelTimer;
- (void)startTimer;

@end
