//
//  ScoreDetailInfoCollectionViewCell.h
//  sportsball-ios
//
//  Created by Mike Silvis on 12/4/14.
//  Copyright (c) 2014 Mike Silvis. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SBScoreDetail.h"
#import "SBGame.h"

@interface SBScoreDetailInfoCollectionViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *summary;
@property (weak, nonatomic) IBOutlet UIImageView *teamLogo;
@property (weak, nonatomic) IBOutlet UILabel *time;
@property (weak, nonatomic) IBOutlet UILabel *teamName;

@property (nonatomic, strong) NSArray *contentInfo;
@property (nonatomic, strong) SBGame *game;

@end
