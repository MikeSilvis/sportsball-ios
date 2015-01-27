//
//  ScoreDataInfoTableViewCell.m
//  sportsball-ios
//
//  Created by Mike Silvis on 1/12/15.
//  Copyright (c) 2015 Mike Silvis. All rights reserved.
//

#import "SBScoreDataInfoTableViewCell.h"

@implementation SBScoreDataInfoTableViewCell

- (void)awakeFromNib {
  [super awakeFromNib];
  
  self.contentView.backgroundColor = [UIColor clearColor];
  self.backgroundColor = [UIColor clearColor];
  self.selectionStyle = UITableViewCellSelectionStyleNone;
}

@end
