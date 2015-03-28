//
//  SBTabViewViewController.m
//  sportsball-ios
//
//  Created by Mike Silvis on 3/27/15.
//  Copyright (c) 2015 Mike Silvis. All rights reserved.
//

#import "SBTabViewViewController.h"

@interface SBTabViewViewController ()

@end

@implementation SBTabViewViewController

- (void)viewDidLoad {
  [super viewDidLoad];

  [self buildTabbar];
}

- (void)buildTabbar {
  self.tabBar.backgroundColor = [UIColor clearColor];
  [self.tabBar setBackgroundImage:[UIImage new]];
}


@end
