//
//  CSCell.h
//  CSStickyHeaderFlowLayoutDemo
//
//  Created by Jamz Tang on 8/1/14.
//  Copyright (c) 2014 Jamz Tang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CSCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UIImageView *awayTeamLogo;
@property (weak, nonatomic) IBOutlet UIImageView *homeTeamLogo;
@property (weak, nonatomic) IBOutlet UILabel *homeTeamName;
@property (weak, nonatomic) IBOutlet UILabel *awayTeamName;

@property (weak, nonatomic) IBOutlet UIImageView *headerBackground;

@end
