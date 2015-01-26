//
//  SportsBallTableViewCell.m
//  sportsball-ios
//
//  Created by Mike Silvis on 1/9/15.
//  Copyright (c) 2015 Mike Silvis. All rights reserved.
//

#import "SportsBallTableViewCell.h"

@interface SportsBallTableViewCell ()

@property (nonatomic, strong) UIView *separatorLineView;

@end

@implementation SportsBallTableViewCell

- (void)awakeFromNib {
  [super awakeFromNib];

  // Seperator
  self.separatorLineView = [[UIView alloc] init];
  self.separatorLineView.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0.5f];
  self.separatorLineView.hidden = YES;
  [self addSubview:self.separatorLineView];
}

- (void)layoutSubviews {
  [super layoutSubviews];

  CGFloat height = 0.5f;
  int y = self.frame.size.height - height;
  self.separatorLineView.frame = CGRectMake(0, y, self.bounds.size.width, height);

  if (self.renderSeperator) {
    self.separatorLineView.hidden = NO;
  }
}

@end
