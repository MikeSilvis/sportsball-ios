//
//  ScoreIndexView.h
//  sportsball-ios
//
//  Created by Mike Silvis on 11/6/14.
//  Copyright (c) 2014 Mike Silvis. All rights reserved.
//

#import "SBLeague.h"
#import "SBLeagueIndexView.h"
#import "DIDatepicker.h"
#import "SBGame.h"
#import "SBLeagueHeader.h"
#import "SBDatePickerCollectionViewCell.h"

@interface SBScoreIndexView : SBLeagueIndexView <UICollectionViewDataSource, UICollectionViewDelegate, SBDatePickerCollectionViewCellDelegate>

@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;

@property (nonatomic, strong) SBLeague *league;

- (void)findGames;
- (void)cancelTimer;
- (void)startTimer;

@end
