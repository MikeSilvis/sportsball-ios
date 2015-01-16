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

-(void)awakeFromNib {
  [super awakeFromNib];

  self.contentView.backgroundColor = [UIColor redColor];
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
