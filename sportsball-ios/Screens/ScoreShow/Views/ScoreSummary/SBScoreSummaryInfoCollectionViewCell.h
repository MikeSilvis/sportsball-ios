//
//  ScoreSummaryInfoCollectionViewCell.h
//  sportsball-ios
//
//  Created by Mike Silvis on 12/4/14.
//  Copyright (c) 2014 Mike Silvis. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SBGame.h"
#import "SBStanding.h"

@interface SBScoreSummaryInfoCollectionViewCell : UICollectionViewCell

@property (weak, nonatomic) IBOutlet UILabel *textLabel;
@property (nonatomic, strong) SBGame *game;
@property (nonatomic, strong) NSIndexPath *indexPath;

@property (nonatomic, strong) SBStanding *standing;
@property (nonatomic, strong) NSIndexPath *outerIndexPath;

@end
