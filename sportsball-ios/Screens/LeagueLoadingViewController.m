//
//  LeagueLoadingViewController.m
//  sportsball-ios
//
//  Created by Mike Silvis on 12/27/14.
//  Copyright (c) 2014 Mike Silvis. All rights reserved.
//

#import "LeagueLoadingViewController.h"
#import "League.h"
#import "LeagueIndexViewController.h"
#import "User.h"

@implementation LeagueLoadingViewController

-(void)viewDidLoad {
  [super viewDidLoad];

  [self didStartLoading];
  
}

-(void)viewDidAppear:(BOOL)animated {
  [super viewDidAppear:animated];
  
  if ([User currentUser].leagues) {
    [League getSupportedLeagues:^(NSArray *leagues) {
      self.leagues = leagues;
    } failure:nil];
  }
}

-(void)setLeagues:(NSArray *)leagues {
  _leagues = leagues;

  [self performSegueWithIdentifier:@"leagueIndexSegue" sender:self];
}

-(UIStatusBarStyle)preferredStatusBarStyle{ 
  return UIStatusBarStyleLightContent;
}

@end
