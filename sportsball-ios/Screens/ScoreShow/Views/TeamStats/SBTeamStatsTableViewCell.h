//
//  SBTeamStatsTableViewCell.h
//  sportsball-ios
//
//  Created by Mike Silvis on 1/28/15.
//  Copyright (c) 2015 Mike Silvis. All rights reserved.
//

#import "SBTableViewCell.h"
#import "SBGameStats.h"

@interface SBTeamStatsTableViewCell : SBTableViewCell <UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) SBGameStats *gameStats;

+ (CGSize)measureCellSizeWithResource:(NSArray *)resource andWidth:(CGFloat)width;

@end
