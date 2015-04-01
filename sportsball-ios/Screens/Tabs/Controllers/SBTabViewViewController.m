//
//  SBTabViewViewController.m
//  sportsball-ios
//
//  Created by Mike Silvis on 3/27/15.
//  Copyright (c) 2015 Mike Silvis. All rights reserved.
//

#import "SBTabViewViewController.h"
#import "SBUser.h"
#import "SBPagingViewController.h"

@interface SBTabViewViewController ()

@end

@implementation SBTabViewViewController

- (void)viewDidLoad {
  [super viewDidLoad];

  [self buildTabbar];
}

- (void)viewDidAppear:(BOOL)animated {
  [super viewDidAppear:animated];

  NSInteger lastOpened = [[SBUser currentUser].lastOpenedScoreOrStandings integerValue];
  if (lastOpened) {
    [self setSelectedIndex:lastOpened];
  }
}

- (void)buildTabbar {
  self.tabBar.backgroundColor = [UIColor clearColor];
  [self.tabBar setBackgroundImage:[UIImage new]];
}

- (void)tabBar:(UITabBar *)tabBar didSelectItem:(UITabBarItem *)item {
  if ([item.title isEqualToString:@"Scores"]) {
    [SBUser currentUser].lastOpenedScoreOrStandings = @0;
  }
  else {
    [SBUser currentUser].lastOpenedScoreOrStandings = @1;
  }
}


@end
