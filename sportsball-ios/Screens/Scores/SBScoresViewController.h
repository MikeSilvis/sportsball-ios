//
//  SBScoresViewController.h
//  sportsball-ios
//
//  Created by Mike Silvis on 3/27/15.
//  Copyright (c) 2015 Mike Silvis. All rights reserved.
//

#import "SBViewController.h"
#import "SBLeague.h"

@interface SBScoresViewController : SBViewController <UICollectionViewDataSource, UICollectionViewDelegate>

@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (weak, nonatomic) IBOutlet UIToolbar *toolBar;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *hamburgerButton;
- (IBAction)hamburgerClicked:(id)sender;

@property (nonatomic, strong) SBLeague *league;

@end
