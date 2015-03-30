//
//  SBStandingsView.h
//  sportsball-ios
//
//  Created by Mike Silvis on 3/18/15.
//  Copyright (c) 2015 Mike Silvis. All rights reserved.
//

#import "SBLeague.h"
#import "SBUser.h"
#import "SBLeagueHeader.h"
#import "SBStanding.h"
#import "SBStanding.h"

@interface SBStandingsViewCell : UICollectionViewCell <UICollectionViewDataSource, UICollectionViewDelegate>

@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;

@property (nonatomic, strong) SBLeague *league;
@property (nonatomic, strong) SBStanding *standing;

- (void)cancelTimer;
- (void)startTimer;

@end
