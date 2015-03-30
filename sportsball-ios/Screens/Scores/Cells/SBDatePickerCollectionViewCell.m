//
//  SBDatePickerCollectionViewCell.m
//  sportsball-ios
//
//  Created by Mike Silvis on 3/9/15.
//  Copyright (c) 2015 Mike Silvis. All rights reserved.
//

#import "SBDatePickerCollectionViewCell.h"

@implementation SBDatePickerCollectionViewCell

- (void)awakeFromNib {
  self.backgroundColor = [UIColor blackColor];

  [self.datePicker addTarget:self action:@selector(updateSelectedDate) forControlEvents:UIControlEventValueChanged];
}

- (void)setDates:(NSArray *)dates {
  _dates = dates;
  
  self.datePicker.dates = self.dates;
}

- (void)updateSelectedDate {
  if (self.delegate && self.datePicker.selectedDate) {
    [self.delegate updateSelectedDate:self.datePicker.selectedDate];
  }
}

@end
