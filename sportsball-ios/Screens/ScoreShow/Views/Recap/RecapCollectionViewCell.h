//
//  RecapCollectionViewCell.h
//  sportsball-ios
//
//  Created by Mike Silvis on 12/23/14.
//  Copyright (c) 2014 Mike Silvis. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Recap.h"

@interface RecapCollectionViewCell : UICollectionViewCell

@property (nonatomic, strong) Recap *recap;
@property (weak, nonatomic) IBOutlet UILabel *content;
@property (weak, nonatomic) IBOutlet UILabel *headline;

+(CGSize)measureCellSizeWithResource:(Recap *)resource andWidth:(CGFloat)width;

@end
