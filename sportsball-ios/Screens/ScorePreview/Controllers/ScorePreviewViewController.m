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
#import "RecapCollectionViewCell.h"

@implementation ScorePreviewViewController

// Cell Identifiers
static NSString * scoreRecapCollectionViewCell = @"scoreRecapCollectionViewCell";

// Cell Locations
static const NSInteger scoreRecapViewLocation = 0;

- (void)viewDidLoad {
  [super viewDidLoad];

  // Collection View Styles
  self.tableView.backgroundColor = [UIColor clearColor];
  self.tableView.indicatorStyle = UIScrollViewIndicatorStyleWhite;
  self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;

  // Register nibs
  [self.tableView registerNib:[UINib nibWithNibName:@"RecapCollectionViewCell" bundle:nil]
        forCellReuseIdentifier:scoreRecapCollectionViewCell];


  // Close Icon
  CGFloat iconSize = 25;
  FAKFontAwesome *closeIcon = [FAKFontAwesome timesIconWithSize:iconSize];
  [self.closeButton setImage:[UIImage imageWithFontAwesomeIcon:closeIcon andSize:iconSize andColor:@"#fff"] forState:UIControlStateNormal];
  [self.closeButton setTitle:@"" forState:UIControlStateNormal];
  [self.closeButton addTarget:self action:@selector(closeModal) forControlEvents:UIControlEventTouchDown];

  self.loadingIndicator.hidden = YES;
}

-(void)viewWillAppear:(BOOL)animated {
  [super viewWillAppear:animated];

  if (!self.game.preview) {
    self.loadingIndicator.hidden = NO;
  }

  [self.game findPreview:nil success:^(Preview *preview) {
    self.game.preview = preview;

    self.loadingIndicator.hidden = YES;

    [self.tableView reloadData];
  } failure:nil];

  [self setHeaderInfo];
}

-(void)closeModal {
  [self dismissViewControllerAnimated:YES completion:nil];
}

-(void)setGame:(Game *)game {
  [super setGame:game];

  [self.tableView reloadData];

  [self setHeaderInfo];
}

-(void)setHeaderInfo {
  Team *homeTeam = self.game.homeTeam;
  [self.homeTeamLogo setImageWithURL:[homeTeam imageURLWithSize:homeTeam.logoUrl andSize:@"120x120"]];

  Team *awayTeam = self.game.awayTeam;
  [self.awayTeamLogo setImageWithURL:[awayTeam imageURLWithSize:awayTeam.logoUrl andSize:@"120x120"]];
}

#pragma mark - Table View

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
  return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
  return 1;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  if (indexPath.section == scoreRecapViewLocation) {
    RecapCollectionViewCell *cell = [tableView dequeueReusableCellWithIdentifier:scoreRecapCollectionViewCell forIndexPath:indexPath];
    cell.preview = self.game.preview;

    return cell;
  }

  return nil;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
  return 0;
}

@end
