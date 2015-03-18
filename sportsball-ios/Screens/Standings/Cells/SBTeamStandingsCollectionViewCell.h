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
@property (weak, nonatomic) IBOutlet UILabel *statOne;
@property (weak, nonatomic) IBOutlet UILabel *statTwo;
@property (weak, nonatomic) IBOutlet UILabel *statThree;
@property (weak, nonatomic) IBOutlet UILabel *statFour;
@property (weak, nonatomic) IBOutlet UILabel *statFive;

@end
