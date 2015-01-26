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
#import <CSNotificationView.h>

@implementation LeagueLoadingViewController

-(void)viewDidLoad {
  [super viewDidLoad];

  [self didStartLoading];
  
}

-(void)viewDidAppear:(BOOL)animated {
  [super viewDidAppear:animated];
  
  if ([User currentUser].leagues) {
    [self requestLeagues];
  }
}

-(void)requestLeagues {
  [League getSupportedLeagues:^(NSArray *leagues) {
    self.leagues = leagues;
  } failure:^(NSError *error) {
    [CSNotificationView showInViewController:self style:CSNotificationViewStyleError message:error.localizedDescription];
  }];
}

-(void)setLeagues:(NSArray *)leagues {
  _leagues = leagues;

  [self performSegueWithIdentifier:@"leagueIndexSegue" sender:self];
}

-(UIStatusBarStyle)preferredStatusBarStyle{ 
  return UIStatusBarStyleLightContent;
}

@end
