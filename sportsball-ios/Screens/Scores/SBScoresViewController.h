//
//  SBScoresViewController.h
//  sportsball-ios
//
//  Created by Mike Silvis on 3/27/15.
//  Copyright (c) 2015 Mike Silvis. All rights reserved.
//

#import "SBViewController.h"
#import "SBLeague.h"
#import "SBPagingViewController.h"

@interface SBScoresViewController : SBViewController <SBPagingViewDelegate>

@property (nonatomic, strong) SBLeague *league;

@end
