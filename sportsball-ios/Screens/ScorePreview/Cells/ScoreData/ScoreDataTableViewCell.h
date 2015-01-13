//
//  ScoreDataTableViewCell.h
//  sportsball-ios
//
//  Created by Mike Silvis on 1/12/15.
//  Copyright (c) 2015 Mike Silvis. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Game.h"

@interface ScoreDataTableViewCell : UITableViewCell <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) Game *game;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) NSArray *elements;

+(CGSize)measureCellSizeWithResource:(Game *)game andWidth:(CGFloat)width;

@end
