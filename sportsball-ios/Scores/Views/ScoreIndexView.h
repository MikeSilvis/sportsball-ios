//
//  ScoreIndexView.h
//  sportsball-ios
//
//  Created by Mike Silvis on 11/6/14.
//  Copyright (c) 2014 Mike Silvis. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "League.h"

@protocol ScoreIndexViewDelegate <NSObject>

-(void)didRequestClose;

@end

@interface ScoreIndexView : UIView <UICollectionViewDataSource, UICollectionViewDelegate>

@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;

@property (nonatomic, retain) League *league;
@property (nonatomic, strong) UINib *headerNib;
@property (nonatomic, retain) NSArray *games;
@property (nonatomic, retain) NSTimer *scorePuller;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *leagueBarButton;
@property (weak, nonatomic) IBOutlet UIToolbar *toolBar;

@property (nonatomic, weak) id<ScoreIndexViewDelegate> delegate;

- (IBAction)leagueBarButtonClicked:(id)sender;
-(void)findGames:(BOOL)showLoader;
-(void)cancelTimer;
-(void)startTimer;

@end