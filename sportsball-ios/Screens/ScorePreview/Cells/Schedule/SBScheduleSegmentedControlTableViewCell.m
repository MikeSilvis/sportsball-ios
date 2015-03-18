//
//  ScheduleSegmentedControlTableViewCell.m
//  sportsball-ios
//
//  Created by Mike Silvis on 1/15/15.
//  Copyright (c) 2015 Mike Silvis. All rights reserved.
//

#import "SBScheduleSegmentedControlTableViewCell.h"

static int kAwayIndex = 0;
static int kHomeIndex = 1;
static int kHeaderHeight = 44;

@implementation SBScheduleSegmentedControlTableViewCell

-(void)layoutSubviews {
  [super layoutSubviews];

  // Hack to ensure control is centered & Full width
  CGFloat screenWidth = [UIScreen mainScreen].bounds.size.width;
  CGFloat width = (screenWidth / 2) - 20;
  [self.segmentedControl setWidth:width forSegmentAtIndex:kAwayIndex];
  [self.segmentedControl setWidth:width forSegmentAtIndex:kHomeIndex];

  CGFloat controlWidth = width * 2;
  CGRect f = self.segmentedControl.frame;
  f.origin.x = (screenWidth - controlWidth) / 2;
  self.segmentedControl.frame = f;
}

-(void)setGame:(SBGame *)game {
  _game = game;

  [self.segmentedControl setTitle:self.game.awayTeam.name forSegmentAtIndex:kAwayIndex];
  [self.segmentedControl setTitle:self.game.homeTeam.name forSegmentAtIndex:kHomeIndex];
}

-(void)setSelectedTeam:(SBTeam *)selectedTeam {
  _selectedTeam = selectedTeam;

  if (self.selectedTeam.isAway) {
    [self.segmentedControl setSelectedSegmentIndex:kAwayIndex];
  }
  else {
    [self.segmentedControl setSelectedSegmentIndex:kHomeIndex];
  }
}

- (IBAction)indexChanged:(UISegmentedControl *)sender {
  if (self.segmentedControl.selectedSegmentIndex == kAwayIndex) {
    [self.delegate changedTeam:self.game.awayTeam];
  }
  else if (self.segmentedControl.selectedSegmentIndex == kHomeIndex) {
    [self.delegate changedTeam:self.game.homeTeam];
  }
}

+(CGSize)measureCellSizeWithResource:(SBGame *)resource andWidth:(CGFloat)width {
  return CGSizeMake(width, kHeaderHeight);
}

@end
