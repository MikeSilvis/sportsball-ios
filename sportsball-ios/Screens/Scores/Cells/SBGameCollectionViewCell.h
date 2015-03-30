//
//  GameCollectionViewCell.h
//  sportsball-ios
//
//  Created by Mike Silvis on 11/6/14.
//  Copyright (c) 2014 Mike Silvis. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SBGame.h"

@interface SBGameCollectionViewCell : UICollectionViewCell

@property (weak, nonatomic) IBOutlet UIImageView *homeTeamLogo;
@property (weak, nonatomic) IBOutlet UILabel *homeTeamName;
@property (weak, nonatomic) IBOutlet UILabel *homeTeamRecord;
@property (weak, nonatomic) IBOutlet UIImageView *awayTeamLogo;
@property (weak, nonatomic) IBOutlet UILabel *awayTeamName;
@property (weak, nonatomic) IBOutlet UILabel *awayTeamRecord;
@property (weak, nonatomic) IBOutlet UIImageView *homeTeamWinner;
@property (weak, nonatomic) IBOutlet UIImageView *awayTeamWinner;
@property (weak, nonatomic) IBOutlet UILabel *upperInfo;
@property (weak, nonatomic) IBOutlet UILabel *lowerInfo;
@property (weak, nonatomic) IBOutlet UILabel *homeTeamScore;
@property (weak, nonatomic) IBOutlet UILabel *awayTeamScore;
@property (weak, nonatomic) IBOutlet UILabel *awayTeamRank;
@property (weak, nonatomic) IBOutlet UILabel *homeTeamRank;
@property(nonatomic, strong) SBGame *currentGame;

@end
