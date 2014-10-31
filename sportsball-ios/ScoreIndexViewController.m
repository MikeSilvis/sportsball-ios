//
//  ScoreIndexViewController.m
//  sportsball-ios
//
//  Created by Mike Silvis on 10/31/14.
//  Copyright (c) 2014 Mike Silvis. All rights reserved.
//

#import "ScoreIndexViewController.h"
#import <SDWebImage/UIImageView+WebCache.h>

@implementation ScoreIndexViewController

- (void)viewDidLoad {
  Team *awayTeam = [[Team alloc] init];
  awayTeam.name = @"Panthers";
  awayTeam.logoUrl = [NSURL URLWithString:@"http://upload.wikimedia.org/wikipedia/ang/c/cd/Panthers_tacn.png"];
  awayTeam.wins = @4;
  awayTeam.loses = @3;

  Team *homeTeam = [[Team alloc] init];
  homeTeam.name = @"Penguins";
  homeTeam.logoUrl = [NSURL URLWithString:@"http://img4.wikia.nocookie.net/__cb20100914172946/logopedia/images/0/00/200px-Pittsburgh_Penguins_logo_1972-1992_svg.png"];
  homeTeam.wins = @6;
  homeTeam.loses = @1;

  Game *game1 = [[Game alloc] init];
  game1.awayTeam = awayTeam;
  game1.homeTeam = homeTeam;

  self.games = @[
                 game1,
                 game1,
                 game1,
                 game1,
                 game1,
                 game1,
                 game1,
                 game1,
                 game1
                ];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
  return self.games.count;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
  return 1;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
  return 80;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
  return 200;
}

//-(UIView *) tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
//    static NSString *CellIdentifier = @"headerTableViewCell";
//    HeaderTableViewCell *headerView = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
//
//    if (headerView == nil) {
//      headerView = [[HeaderTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
//    }
//
//    headerView.title.text = @"NHL";
//
//    return headerView;
//}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  static NSString *simpleTableIdentifier = @"gameTableViewCell";
  GameTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];

  if (cell == nil) {
    cell = [[GameTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:simpleTableIdentifier];
  }

  Game *currentGame = self.games[indexPath.row];

  // Home Team
  Team *homeTeam = currentGame.homeTeam;
  cell.homeTeamLabel.text = homeTeam.name;
  cell.homeTeamScore.text = @"5";
  [cell.homeTeamLogo sd_setImageWithURL:homeTeam.logoUrl placeholderImage:nil];

  // Away Team
  Team *awayTeam = currentGame.awayTeam;
  cell.awayTeamLabel.text = awayTeam.name;
  cell.awayTeamScore.text = @"3";
  [cell.awayTeamLogo sd_setImageWithURL:awayTeam.logoUrl placeholderImage:nil];

  return cell;
}

//- (NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath{
//    if (indexPath.section == 0) {
//      return nil;
//    }
//
//    return indexPath;
//}

@end
