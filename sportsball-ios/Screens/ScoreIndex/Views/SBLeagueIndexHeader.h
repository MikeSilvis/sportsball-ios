//
//  LeagueIndexHeader.h
//  sportsball-ios
//
//  Created by Mike Silvis on 11/6/14.
//  Copyright (c) 2014 Mike Silvis. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SBLeague.h"

@interface SBLeagueIndexHeader : UIView

@property (nonatomic, strong) SBLeague *league;
@property (weak, nonatomic) IBOutlet UIImageView *backgroundImage;
@property (weak, nonatomic) IBOutlet UIImageView *logoImage;

@end
