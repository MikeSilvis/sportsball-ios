//
//  RecapCollectionViewCell.h
//  sportsball-ios
//
//  Created by Mike Silvis on 12/23/14.
//  Copyright (c) 2014 Mike Silvis. All rights reserved.
//

#import "SportsBallTableViewCell.h"
#import "SBGame.h"

@interface ContentTableViewCell : SportsBallTableViewCell

@property (nonatomic, strong) SBRecap *recap;
@property (nonatomic, strong) SBPreview *preview;
@property (weak, nonatomic) IBOutlet UILabel *content;
@property (weak, nonatomic) IBOutlet UILabel *headline;
@property (weak, nonatomic) IBOutlet UIImageView *headerImage;

+ (CGSize)measureCellSizeWithResource:(SBGame *)resource andWidth:(CGFloat)width;

@end
