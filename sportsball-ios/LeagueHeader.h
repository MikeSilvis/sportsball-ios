//
//  CSAlwaysOnTopHeader.h
//  CSStickyHeaderFlowLayoutDemo
//
//  Created by James Tang on 6/4/14.
//  Copyright (c) 2014 Jamz Tang. All rights reserved.
//

#import "GameUICollectionViewCell.h"

@interface LeagueHeader : GameUICollectionViewCell

@property (weak, nonatomic) IBOutlet UIImageView *smallLogo;
@property (weak, nonatomic) IBOutlet UIImageView *largeLogo;

@property (retain, nonatomic) UIImage *blurredImage;
@property (retain, nonatomic) UIImage *largeLogoImage;


@end
