//
//  ScoreDataInfoTableViewCell.m
//  sportsball-ios
//
//  Created by Mike Silvis on 1/12/15.
//  Copyright (c) 2015 Mike Silvis. All rights reserved.
//

#import "ScoreDataInfoTableViewCell.h"

@implementation ScoreDataInfoTableViewCell

- (void)awakeFromNib {
  [super awakeFromNib];
  
  self.contentView.backgroundColor = [UIColor clearColor];
  self.backgroundColor = [UIColor clearColor];
  self.selectionStyle = UITableViewCellSelectionStyleNone;
}

@end
