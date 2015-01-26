//
//  CSAlwaysOnTopHeader.h
//  CSStickyHeaderFlowLayoutDemo
//
//  Created by James Tang on 6/4/14.
//  Copyright (c) 2014 Jamz Tang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "League.h"


@protocol LeagueHeaderProtocal <NSObject>

- (void)logoClicked;

@end

@interface LeagueHeader : UICollectionViewCell

@property (weak, nonatomic) IBOutlet UIImageView *smallLogo;
@property (weak, nonatomic) IBOutlet UIImageView *headerImage;
@property (weak, nonatomic) IBOutlet UIImageView *headerImageBlurred;

@property (nonatomic, strong) UIImage *largeLogoImage;

@property (nonatomic, strong) League *currentLeague;

@property (nonatomic, weak) id<LeagueHeaderProtocal> delegate;

@end
