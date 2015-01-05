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

@implementation LeagueLoadingViewController

- (void)viewDidLoad {
  [super viewDidLoad];

}
-(void)viewDidAppear:(BOOL)animated {
  [super viewDidAppear:animated];
  
  if (!self.leagues) {
    [self didStartLoading];
    [League getSupportedLeagues:^(NSArray *leagues) {
      self.leagues = leagues;
    } failure:nil];
  }
}

-(void)setLeagues:(NSArray *)leagues {
  _leagues = leagues;

  [self performSegueWithIdentifier:@"leagueIndexSegue" sender:self];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
  LeagueIndexViewController *viewController = segue.destinationViewController;
  viewController.leagues = self.leagues;
}

-(UIStatusBarStyle)preferredStatusBarStyle{ 
  return UIStatusBarStyleLightContent;
}

@end
