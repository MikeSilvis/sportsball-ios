//
//  SBStandingsViewController.m
//  sportsball-ios
//
//  Created by Mike Silvis on 3/10/15.
//  Copyright (c) 2015 Mike Silvis. All rights reserved.
//

#import "SBStandingsViewController.h"

@implementation SBStandingsViewController

- (void)viewDidLoad {
  [super viewDidLoad];

}

- (void)viewDidAppear:(BOOL)animated {
  [super viewDidAppear:animated];

  self.league = [SBUser currentUser].lastOpenedLeague;
}

@end