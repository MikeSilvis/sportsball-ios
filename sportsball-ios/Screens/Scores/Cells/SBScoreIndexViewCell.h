//
//  ScoreIndexView.h
//  sportsball-ios
//
//  Created by Mike Silvis on 11/6/14.
//  Copyright (c) 2014 Mike Silvis. All rights reserved.
//

#import "SBLeague.h"
#import "DIDatepicker.h"
#import "SBGame.h"
#import "SBLeagueHeader.h"
#import "SBDatePickerCollectionViewCell.h"

@protocol SBScoreIndexViewCellDelegate <NSObject>

- (void)askForFavoriteTeam:(SBTeam *)team;
- (void)selectedGame:(SBGame *)game;

@end

@interface SBScoreIndexViewCell : UICollectionViewCell <UICollectionViewDataSource, UICollectionViewDelegate, SBDatePickerCollectionViewCellDelegate>

@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;

@property (nonatomic, weak) id<SBScoreIndexViewCellDelegate> delegate;
@property (nonatomic, strong) SBLeague *league;

- (void)cancelTimer;
- (void)startTimer;

@end
