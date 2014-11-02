//
//  CSCell.h
//  CSStickyHeaderFlowLayoutDemo
//
//  Created by Jamz Tang on 8/1/14.
//  Copyright (c) 2014 Jamz Tang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GameOverCell : UICollectionViewCell

@property (weak, nonatomic) IBOutlet UIImageView *awayTeamLogo;
@property (weak, nonatomic) IBOutlet UIImageView *homeTeamLogo;
@property (weak, nonatomic) IBOutlet UILabel *homeTeamName;
@property (weak, nonatomic) IBOutlet UILabel *awayTeamName;
@property (weak, nonatomic) IBOutlet UILabel *homeScore;
@property (weak, nonatomic) IBOutlet UILabel *awayScore;
@property (weak, nonatomic) IBOutlet UIImageView *homeWinnerImage;
@property (weak, nonatomic) IBOutlet UIImageView *awayWinnerImage;
@property (weak, nonatomic) IBOutlet UILabel *homeRecord;
@property (weak, nonatomic) IBOutlet UILabel *awayRecord;

@property (weak, nonatomic) IBOutlet UIImageView *headerBackground;
@property (weak, nonatomic) IBOutlet UILabel *timeRemaining;
@property (weak, nonatomic) IBOutlet UILabel *currentPeriod;

@end
