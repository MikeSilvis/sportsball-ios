//
//  ScoreShowHeader.h
//  sportsball-ios
//
//  Created by Mike Silvis on 11/23/14.
//  Copyright (c) 2014 Mike Silvis. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Game.h"
#import "Team.h"

@interface ScoreShowHeader : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UIImageView *homeTeamLogo;
@property (weak, nonatomic) IBOutlet UILabel *homeTeamScore;
@property (weak, nonatomic) IBOutlet UIImageView *homeTeamWinnerImage;

@property (weak, nonatomic) IBOutlet UIImageView *awayTeamLogo;
@property (weak, nonatomic) IBOutlet UILabel *awayTeamScore;
@property (weak, nonatomic) IBOutlet UIImageView *awayTeamWinnerImage;

@property (weak, nonatomic) IBOutlet UILabel *upperInfo;
@property (weak, nonatomic) IBOutlet UILabel *lowerInfo;

@property (nonatomic, strong) Game *game;

@end
