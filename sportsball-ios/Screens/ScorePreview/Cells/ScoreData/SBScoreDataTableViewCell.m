//
//  ScoreDataTableViewCell.m
//  sportsball-ios
//
//  Created by Mike Silvis on 1/12/15.
//  Copyright (c) 2015 Mike Silvis. All rights reserved.
//

#import "SBScoreDataTableViewCell.h"
#import "SBScoreDataInfoTableViewCell.h"

@implementation SBScoreDataTableViewCell

static int const kCellRowHeight = 20;
static NSString * const kScoreDataInfoViewCell = @"ScoreDataInfoViewCell";

- (void)awakeFromNib {
  self.backgroundColor = [UIColor clearColor];

  self.tableView.backgroundColor = [UIColor clearColor];
  self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;

  // Register Nibs
  [self.tableView registerNib:[UINib nibWithNibName:@"SBScoreDataInfoTableViewCell" bundle:nil]
       forCellReuseIdentifier:kScoreDataInfoViewCell];
}

- (void)setGame:(SBGame *)game {
  _game = game;

  _elements = nil;

  if ([[self.elements allKeys] count] > 0) {
    self.renderSeperator = YES;
  }

  [self.tableView reloadData];
}

- (NSDictionary *)elements {
  if (!_elements) {
    _elements = [self.class calculateElements:self.game];
  }

  return _elements;
}

+ (NSDictionary *)calculateElements:(SBGame *)game {
  NSMutableDictionary *elements = [NSMutableDictionary dictionary];

  if (game.moneyLine) {
    elements[@"Odds"] = game.moneyLine;
  }
  if (game.preview && game.preview.gameInfo) {
    [elements addEntriesFromDictionary:game.preview.gameInfo.elements];
  }
  else if (game.boxscore && game.boxscore.gameInfo) {
    [elements addEntriesFromDictionary:game.boxscore.gameInfo.elements];
  }

  return elements;
}

#pragma mark - Table Methods

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  SBScoreDataInfoTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kScoreDataInfoViewCell forIndexPath:indexPath];
  NSString *currentKey = [self.elements allKeys][indexPath.row];

  cell.header.text = [NSString stringWithFormat:@"%@:", currentKey];
  cell.info.text   = self.elements[currentKey];

  return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
  return kCellRowHeight;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
  return [self.class numOfRows:self.game];
}

#pragma mark - Measure

+ (CGSize)measureCellSizeWithResource:(SBGame *)game andWidth:(CGFloat)width {
  CGFloat height = 20;
  height = height + [self numOfRows:game] * kCellRowHeight;

  return CGSizeMake(width, height);
}

+ (NSUInteger)numOfRows:(SBGame *)game {
  return [[[self calculateElements:game] allKeys] count];
}


@end
