//
//  ScorePreviewViewController.m
//  sportsball-ios
//
//  Created by Mike Silvis on 1/8/15.
//  Copyright (c) 2015 Mike Silvis. All rights reserved.
//

#import "ScorePreviewViewController.h"
#import "UIImage+FontAwesome.h"
#import <UIImageView+AFNetworking.h>
#import "ContentTableViewCell.h"
#import "ScoreDataTableViewCell.h"
#import "ScheduleTableViewCell.h"

@interface ScorePreviewViewController ()

@property BOOL shouldRenderTable;

@end

@implementation ScorePreviewViewController

// Cell Identifiers
static NSString * scoreContentCell = @"scoreContentCell";
static NSString * scoreDataCell = @"scoreDataCell";
static NSString * scheduleCell = @"scheduleTableViewCell";

// Cell Locations
static const NSInteger scoreRecapViewLocation = 0;
static const NSInteger scoreDataViewLocation  = 1;
static const NSInteger scheduleCellLocation   = 2;

- (void)viewDidLoad {
  [super viewDidLoad];

  // Collection View Styles
  self.tableView.backgroundColor = [UIColor clearColor];
  self.tableView.indicatorStyle = UIScrollViewIndicatorStyleWhite;
  self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;

  // Register nibs
  [self.tableView registerNib:[UINib nibWithNibName:@"ContentTableViewCell" bundle:nil]
        forCellReuseIdentifier:scoreContentCell];
  [self.tableView registerNib:[UINib nibWithNibName:@"ScoreDataTableViewCell" bundle:nil]
        forCellReuseIdentifier:scoreDataCell];
  [self.tableView registerNib:[UINib nibWithNibName:@"ScheduleTableViewCell" bundle:nil]
        forCellReuseIdentifier:scheduleCell];

  // Close Icon
  CGFloat iconSize = 25;
  FAKFontAwesome *closeIcon = [FAKFontAwesome timesIconWithSize:iconSize];
  [self.closeButton setImage:[UIImage imageWithFontAwesomeIcon:closeIcon andSize:iconSize andColor:@"#fff"] forState:UIControlStateNormal];
  [self.closeButton setTitle:@"" forState:UIControlStateNormal];
  [self.closeButton addTarget:self action:@selector(closeModal) forControlEvents:UIControlEventTouchDown];

  self.loadingIndicator.hidden = YES;
  self.shouldRenderTable = NO;
}

-(void)viewWillAppear:(BOOL)animated {
  [super viewWillAppear:animated];

  if (!self.game.previewId) {
    [self setDataLoaded];
  }
  else {
    self.loadingIndicator.hidden = NO;

    [self.game findPreview:nil success:^(Preview *preview) {
      self.game.preview = preview;

      [self setDataLoaded];
    } failure:nil];
  }

  [self setHeaderInfo];
}

-(void)setDataLoaded {
  self.shouldRenderTable = YES;
  self.loadingIndicator.hidden = YES;
  [self.tableView reloadData];
}

-(void)closeModal {
  [self dismissViewControllerAnimated:YES completion:nil];
}

-(void)setGame:(Game *)game {
  [super setGame:game];

  [self setHeaderInfo];
}

-(void)setHeaderInfo {
  Team *homeTeam = self.game.homeTeam;
  [self.homeTeamLogo setImageWithURL:[homeTeam imageURL:homeTeam.logoUrl withSize:@"120x120"]];
  self.homeTeamRecord.text = homeTeam.record;
  self.homeTeamName.text = homeTeam.name;

  Team *awayTeam = self.game.awayTeam;
  [self.awayTeamLogo setImageWithURL:[awayTeam imageURL:awayTeam.logoUrl withSize:@"120x120"]];
  self.awayTeamRecord.text = awayTeam.record;
  self.awayTeamName.text = awayTeam.name;
}

#pragma mark - Table View

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
  return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
  if (self.shouldRenderTable) {
    return 3;
  }
  else {
    return 0;
  }
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  if (indexPath.row == scoreRecapViewLocation) {
    ContentTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:scoreContentCell forIndexPath:indexPath];
    cell.preview = self.game.preview;

    return cell;
  }
  else if (indexPath.row == scoreDataViewLocation) {
    ScoreDataTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:scoreDataCell forIndexPath:indexPath];
    cell.game = self.game;

    return cell;
  }
  else if (indexPath.row == scheduleCellLocation) {
    ScheduleTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:scheduleCell forIndexPath:indexPath];
    cell.game = self.game;

    return cell;
  }

  return nil;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
  if (indexPath.row == scoreRecapViewLocation) {
    [self openURL:self.game.preview.url];
  }
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
  CGFloat width = self.view.bounds.size.width;

  if (indexPath.row == scoreRecapViewLocation) {
    return [ContentTableViewCell measureCellSizeWithResource:self.game andWidth:width].height;
  }
  else if (indexPath.row == scoreDataViewLocation) {
    return [ScoreDataTableViewCell measureCellSizeWithResource:self.game andWidth:width].height;
  }
  else if (indexPath.row == scheduleCellLocation) {
    return [ScheduleTableViewCell measureCellSizeWithResource:self.game andWidth:width].height;
  }

  return 0;
}

@end
