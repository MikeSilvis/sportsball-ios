//
//  SBStandingsViewController.h
//  sportsball-ios
//
//  Created by Mike Silvis on 3/10/15.
//  Copyright (c) 2015 Mike Silvis. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SBLeague.h"
#import "SBUser.h"
#import "SBLeagueHeader.h"

@interface SBStandingsViewController : UIViewController <UICollectionViewDataSource, UICollectionViewDelegate>

@property (nonatomic, strong) SBLeague *league;
@property (nonatomic, strong) NSDictionary *divisionStandings;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;

@end
