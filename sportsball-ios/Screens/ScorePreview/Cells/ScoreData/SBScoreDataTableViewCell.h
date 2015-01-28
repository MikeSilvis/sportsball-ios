//
//  ScoreDataTableViewCell.h
//  sportsball-ios
//
//  Created by Mike Silvis on 1/12/15.
//  Copyright (c) 2015 Mike Silvis. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SBGame.h"
#import "SBTableViewCell.h"

@interface SBScoreDataTableViewCell : SBTableViewCell <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) SBGame *game;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) NSDictionary *elements;

+ (CGSize)measureCellSizeWithResource:(SBGame *)game andWidth:(CGFloat)width;

@end
