//
//  ScoreSummaryInfoCollectionViewCell.h
//  sportsball-ios
//
//  Created by Mike Silvis on 12/4/14.
//  Copyright (c) 2014 Mike Silvis. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Game.h"

@interface ScoreSummaryInfoCollectionViewCell : UICollectionViewCell

@property (weak, nonatomic) IBOutlet UILabel *score;
@property (nonatomic, strong) Game *game;
@property NSUInteger section;
@property NSUInteger row;

@end