//
//  SBTeamStandingsCollectionViewCell.h
//  sportsball-ios
//
//  Created by Mike Silvis on 3/17/15.
//  Copyright (c) 2015 Mike Silvis. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SBTeam.h"

@interface SBTeamStandingsCollectionViewCell : UICollectionViewCell

@property (nonatomic, strong) SBTeam *team;
@property (weak, nonatomic) IBOutlet UIImageView *teamLogo;
@property (weak, nonatomic) IBOutlet UILabel *teamName;

@end
