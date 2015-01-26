//
//  ScoreDataTableViewCell.m
//  sportsball-ios
//
//  Created by Mike Silvis on 1/12/15.
//  Copyright (c) 2015 Mike Silvis. All rights reserved.
//

#import "ScoreDataTableViewCell.h"
#import "ScoreDataInfoTableViewCell.h"

@implementation ScoreDataTableViewCell

static int const cellRowHeight = 30;
static NSString * const scoreDataInfoViewCell = @"scoreDataInfoViewCell";

- (void)awakeFromNib {
  self.backgroundColor = [UIColor clearColor];

  self.tableView.backgroundColor = [UIColor clearColor];
  self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;

  // Register Nibs
  [self.tableView registerNib:[UINib nibWithNibName:@"ScoreDataInfoTableViewCell" bundle:nil]
       forCellReuseIdentifier:scoreDataInfoViewCell];
}

-(void)setGame:(Game *)game {
  _game = game;

  _elements = nil;
  [self.tableView reloadData];
}

-(NSArray *)elements {
  if (!_elements) {
    _elements = [self.class calculateElements:self.game];
  }

  return _elements;
}

+(NSArray *)calculateElements:(Game *)game {
  NSMutableArray *localElements = [NSMutableArray array];

  if (game.startTime) {
    [localElements addObject:@[
                               @"Start Time",
                               game.localStartTimeWithDate
                              ]];
  }

  if (game.moneyLine) {
    [localElements addObject:@[
                               @"Odds",
                               game.moneyLine
                              ]];
  }

  if (game.preview) {
    Preview *preview = game.preview;
    if (preview.channel) {
      [localElements addObject:@[
                                 @"Channel",
                                 preview.channel
                                ]];
    }
    if (preview.location) {
      [localElements addObject:@[
                                 @"Location",
                                 preview.location
                                ]];
    }
  }

  return localElements;
}

#pragma mark - Table Methods

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  ScoreDataInfoTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:scoreDataInfoViewCell forIndexPath:indexPath];
  NSArray *currentElement = self.elements[indexPath.row];

  cell.header.text = [NSString stringWithFormat:@"%@:", currentElement[0]];
  cell.info.text   = currentElement[1];

  return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
  return cellRowHeight;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
  return [self.class numOfRows:self.game];
}

#pragma mark - Measure

+(CGSize)measureCellSizeWithResource:(Game *)game andWidth:(CGFloat)width {
  CGFloat height = [self numOfRows:game] * cellRowHeight;

  return CGSizeMake(width, height);
}

+(NSUInteger)numOfRows:(Game *)game {
  return [[self calculateElements:game] count];
}


@end
