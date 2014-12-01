//
//  ScoreShowViewController.h
//  sportsball-ios
//
//  Created by Mike Silvis on 11/13/14.
//  Copyright (c) 2014 Mike Silvis. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Game.h"
#import "Boxscore.h"

@protocol ScoreShowViewDelegate <NSObject>

-(void)dismissedScoreShowViewModal;

@end

@interface ScoreShowViewController : UIViewController <UIGestureRecognizerDelegate, UICollectionViewDelegate, UICollectionViewDataSource>

@property (nonatomic, strong) Game *game;
@property (nonatomic, strong) Boxscore *boxscore;
- (IBAction)didRequestClose:(id)sender;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;

@property (nonatomic, weak) id<ScoreShowViewDelegate> delegate;

@end
