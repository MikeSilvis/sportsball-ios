//
//  CSAlwaysOnTopHeader.h
//  CSStickyHeaderFlowLayoutDemo
//
//  Created by James Tang on 6/4/14.
//  Copyright (c) 2014 Jamz Tang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LeagueHeader : UICollectionViewCell

@property (weak, nonatomic) IBOutlet UIImageView *smallLogo;
@property (weak, nonatomic) IBOutlet UIImageView *largeLogo;

@property (nonatomic, strong) UIImage *blurredImage;
@property (nonatomic, strong) UIImage *largeLogoImage;

@end
