//
//  ScoreDetailInfoCollectionViewCell.h
//  sportsball-ios
//
//  Created by Mike Silvis on 12/4/14.
//  Copyright (c) 2014 Mike Silvis. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ScoreDetail.h"
#import "Game.h"

@interface ScoreDetailInfoCollectionViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *summary;
@property (weak, nonatomic) IBOutlet UIImageView *teamLogo;
@property (weak, nonatomic) IBOutlet UILabel *time;

@property (nonatomic, strong) NSArray *contentInfo;
@property (nonatomic, strong) Game *game;

@end
