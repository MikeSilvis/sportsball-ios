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
@property (nonatomic, strong) UIVisualEffectView *blurView;

@property (weak, nonatomic) IBOutlet UIView *background;

@property (nonatomic, weak) id<ScoreShowViewDelegate> delegate;

@property (weak, nonatomic) IBOutlet UIImageView *homeTeamLogo;
@property (weak, nonatomic) IBOutlet UILabel *homeTeamScore;
@property (weak, nonatomic) IBOutlet UIImageView *homeTeamWinner;

@property (weak, nonatomic) IBOutlet UIImageView *awayTeamLogo;
@property (weak, nonatomic) IBOutlet UILabel *awayTeamScore;
@property (weak, nonatomic) IBOutlet UIImageView *awayTeamWinner;

@property (weak, nonatomic) IBOutlet UILabel *lowerInfo;
@property (weak, nonatomic) IBOutlet UILabel *upperInfo;

@end
