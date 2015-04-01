//
//  SBScores2ViewController.m
//  sportsball-ios
//
//  Created by Mike Silvis on 3/31/15.
//  Copyright (c) 2015 Mike Silvis. All rights reserved.
//

#import "SBScores2ViewController.h"

@interface SBScores2ViewController ()

@end

@implementation SBScores2ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.textLabel2.text = self.league.name;
}

- (void)setLeague:(SBLeague *)league {
    _league = league;

    self.textLabel2.text = @"POOOP";
}



@end
