//
//  RecapCollectionViewCell.h
//  sportsball-ios
//
//  Created by Mike Silvis on 12/23/14.
//  Copyright (c) 2014 Mike Silvis. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Game.h"

@interface RecapCollectionViewCell : UITableViewCell

@property (nonatomic, strong) Recap *recap;
@property (nonatomic, strong) Preview *preview;
@property (weak, nonatomic) IBOutlet UILabel *content;
@property (weak, nonatomic) IBOutlet UILabel *headline;
@property (weak, nonatomic) IBOutlet UIImageView *headerImage;

+(CGSize)measureCellSizeWithResource:(Game *)resource andWidth:(CGFloat)width;

@end
