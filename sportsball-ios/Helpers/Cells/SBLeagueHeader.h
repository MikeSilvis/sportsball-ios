//
//  CSAlwaysOnTopHeader.h
//  CSStickyHeaderFlowLayoutDemo
//
//  Created by James Tang on 6/4/14.
//  Copyright (c) 2014 Jamz Tang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SBLeague.h"

@interface SBLeagueHeader : UICollectionViewCell

@property (weak, nonatomic) IBOutlet UIImageView *headerImage;
@property (weak, nonatomic) IBOutlet UIImageView *headerImageBlurred;
@property (weak, nonatomic) IBOutlet UILabel *leagueText;
@property (weak, nonatomic) IBOutlet UIVisualEffectView *blurEffect;

@property (nonatomic, strong) UIImage *largeLogoImage;
@property (nonatomic, strong) SBLeague *league;
@property (weak, nonatomic) IBOutlet UIView *tintBackground;

@end
