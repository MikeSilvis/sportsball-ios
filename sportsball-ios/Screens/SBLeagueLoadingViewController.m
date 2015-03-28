//
//  LeagueLoadingViewController.m
//  sportsball-ios
//
//  Created by Mike Silvis on 12/27/14.
//  Copyright (c) 2014 Mike Silvis. All rights reserved.
//

#import "SBLeagueLoadingViewController.h"
#import "SBLeague.h"
#import "SBUser.h"
#import "SBUser.h"

@implementation SBLeagueLoadingViewController

static NSString *kLeagueIndexSegue = @"leagueIndexSegue";

- (void)viewDidLoad {
  [super viewDidLoad];

  [self didStartLoading];
}

- (void)viewDidAppear:(BOOL)animated {
  [super viewDidAppear:animated];
  
  if ([SBUser currentUser].leagues) {
    [self requestLeagues];
  }
}

- (void)requestLeagues {
  [SBLeague getSupportedLeagues:^(NSArray *leagues) {
    self.leagues = leagues;
  } failure:^(NSError *error) {
    [self showNetworkError:error];
  }];
}

- (void)setLeagues:(NSArray *)leagues {
  _leagues = leagues;

  [self performSegueWithIdentifier:kLeagueIndexSegue sender:self];
}

- (UIStatusBarStyle)preferredStatusBarStyle{
  return UIStatusBarStyleLightContent;
}

@end
