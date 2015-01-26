//
//  ScoreDetailCollectionViewCell.h
//  sportsball-ios
//
//  Created by Mike Silvis on 12/4/14.
//  Copyright (c) 2014 Mike Silvis. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SBGame.h"

@interface ScoreDetailCollectionViewCell : UITableViewCell <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) NSArray *scoreDetails;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) SBGame *game;

+ (CGSize)measureCellSizeWithResource:(NSArray *)resource andWidth:(CGFloat)width;

@end
