//
//  Created by Dmitry Ivanenko on 14.04.14.
//  Copyright (c) 2014 Dmitry Ivanenko. All rights reserved.
//

#import <UIKit/UIKit.h>


extern const NSTimeInterval kSecondsInDay;
extern const CGFloat kDIDetepickerHeight;


@interface DIDatepicker : UIControl <UICollectionViewDataSource, UICollectionViewDelegate>

// data
@property (strong, nonatomic) NSArray *dates;
@property (strong, nonatomic, readonly) NSDate *selectedDate;

// UI
@property (strong, nonatomic) UIColor *bottomLineColor;
@property (strong, nonatomic) UIColor *selectedDateBottomLineColor;

// methods
- (void)selectDate:(NSDate *)date;
- (void)selectDateAtIndex:(NSUInteger)index;
- (void)selectDateClosestToToday;

@end
