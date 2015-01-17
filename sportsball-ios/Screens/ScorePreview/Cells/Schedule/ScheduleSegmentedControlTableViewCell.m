//
//  ScheduleSegmentedControlTableViewCell.m
//  sportsball-ios
//
//  Created by Mike Silvis on 1/15/15.
//  Copyright (c) 2015 Mike Silvis. All rights reserved.
//

#import "ScheduleSegmentedControlTableViewCell.h"

static int awayIndex = 0;
static int homeIndex = 1;
static int headerHeight = 44;

@implementation ScheduleSegmentedControlTableViewCell

-(void)layoutSubviews {
  [super layoutSubviews];

  // Hack to ensure control is centered & Full width
  CGFloat screenWidth = [UIScreen mainScreen].bounds.size.width;
  CGFloat width = (screenWidth / 2) - 20;
  [self.segmentedControl setWidth:width forSegmentAtIndex:awayIndex];
  [self.segmentedControl setWidth:width forSegmentAtIndex:homeIndex];

  CGFloat controlWidth = self.segmentedControl.frame.size.width;
  CGRect f = self.segmentedControl.frame;
  f.origin.x = (screenWidth - controlWidth) / 2;
  f.origin.y = (self.bounds.size.height - self.segmentedControl.frame.size.height) / 2;
  self.segmentedControl.frame = f;
}

-(void)setGame:(Game *)game {
  _game = game;

  [self.segmentedControl setTitle:self.game.awayTeam.name forSegmentAtIndex:awayIndex];
  [self.segmentedControl setTitle:self.game.homeTeam.name forSegmentAtIndex:homeIndex];
}

-(void)setSelectedTeam:(Team *)selectedTeam {
  _selectedTeam = selectedTeam;

  if (self.selectedTeam.isAway) {
    [self.segmentedControl setSelectedSegmentIndex:awayIndex];
  }
  else {
    [self.segmentedControl setSelectedSegmentIndex:homeIndex];
  }
}

- (IBAction)indexChanged:(UISegmentedControl *)sender {
  if (self.segmentedControl.selectedSegmentIndex == awayIndex) {
    [self.delegate changedTeam:self.game.awayTeam];
  }
  else if (self.segmentedControl.selectedSegmentIndex == homeIndex) {
    [self.delegate changedTeam:self.game.homeTeam];
  }
}

+(CGSize)measureCellSizeWithResource:(Game *)resource andWidth:(CGFloat)width {
  return CGSizeMake(width, headerHeight);
}

@end
