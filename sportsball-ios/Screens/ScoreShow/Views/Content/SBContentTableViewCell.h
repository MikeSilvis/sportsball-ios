//
//  RecapCollectionViewCell.h
//  sportsball-ios
//
//  Created by Mike Silvis on 12/23/14.
//  Copyright (c) 2014 Mike Silvis. All rights reserved.
//

#import "SBTableViewCell.h"
#import "SBGame.h"

@interface SBContentTableViewCell : SBTableViewCell

@property (nonatomic, strong) SBRecap *recap;
@property (nonatomic, strong) SBGame *game;
@property (weak, nonatomic) IBOutlet UILabel *content;
@property (weak, nonatomic) IBOutlet UILabel *headline;
@property (weak, nonatomic) IBOutlet UIImageView *headerImage;

+ (CGSize)measureCellSizeWithResource:(SBGame *)resource andWidth:(CGFloat)width;

@end
