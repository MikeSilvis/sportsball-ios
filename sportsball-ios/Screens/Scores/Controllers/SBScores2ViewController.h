//
//  SBScores2ViewController.h
//  sportsball-ios
//
//  Created by Mike Silvis on 3/31/15.
//  Copyright (c) 2015 Mike Silvis. All rights reserved.
//

#import "SBViewController.h"
#import "SBLeague.h"

@interface SBScores2ViewController : UIViewController

@property (weak, nonatomic) IBOutlet UILabel *textLabel2;
@property NSUInteger pageIndex;
@property (nonatomic, strong) SBLeague *league;

@end
