//
//  SBTeamStatInfoTableViewCell.h
//  sportsball-ios
//
//  Created by Mike Silvis on 1/28/15.
//  Copyright (c) 2015 Mike Silvis. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SBTeamStatInfoTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *stat;
@property (weak, nonatomic) IBOutlet UILabel *homeStat;
@property (weak, nonatomic) IBOutlet UILabel *awayStat;

@end
