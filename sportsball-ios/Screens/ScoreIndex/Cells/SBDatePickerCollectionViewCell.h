//
//  SBDatePickerCollectionViewCell.h
//  sportsball-ios
//
//  Created by Mike Silvis on 3/9/15.
//  Copyright (c) 2015 Mike Silvis. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DIDatepicker.h"

@protocol SBDatePickerCollectionViewCellDelegate <NSObject>

- (void)updateSelectedDate:(NSDate *)selectedDate;

@end

@interface SBDatePickerCollectionViewCell : UICollectionViewCell

@property (nonatomic, strong) NSArray *dates;
@property (weak, nonatomic) IBOutlet DIDatepicker *datePicker;
@property (nonatomic, weak) id<SBDatePickerCollectionViewCellDelegate> delegate;

@end
