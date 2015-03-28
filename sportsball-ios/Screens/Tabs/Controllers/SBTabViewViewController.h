//
//  SBTabViewViewController.h
//  sportsball-ios
//
//  Created by Mike Silvis on 3/27/15.
//  Copyright (c) 2015 Mike Silvis. All rights reserved.
//

#import "SBLeague.h"

@interface SBTabViewViewController : UITabBarController <UITabBarControllerDelegate>

@property (nonatomic, strong) SBLeague *league;

@end
