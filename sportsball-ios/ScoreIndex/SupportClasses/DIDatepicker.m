//
//  Created by Dmitry Ivanenko on 14.04.14.
//  Copyright (c) 2014 Dmitry Ivanenko. All rights reserved.
//

#import "DIDatepicker.h"
#import "DIDatepickerDateView.h"


const NSTimeInterval kSecondsInDay = 86400;
const NSInteger kMondayOffset = 2;
const CGFloat kDIDetepickerHeight = 60.;
const CGFloat kDIDatepickerSpaceBetweenItems = 15.;


@interface DIDatepicker ()

@property (strong, nonatomic) UIScrollView *datesScrollView;

@end


@implementation DIDatepicker

- (void)awakeFromNib
{
    [self setupViews];
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (!self) return self;

    [self setupViews];

    return self;
}

- (void)setupViews
{
    self.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    self.backgroundColor = [UIColor clearColor];
    self.bottomLineColor = [UIColor clearColor];
    self.selectedDateBottomLineColor = [UIColor colorWithRed:0.910 green:0.278 blue:0.128 alpha:1.000];
}


#pragma mark Setters | Getters

- (void)setDates:(NSArray *)dates
{
    _dates = [dates sortedArrayUsingSelector:@selector(compare:)];

    [self updateDatesView];

    self.selectedDate = nil;
}

- (void)setSelectedDate:(NSDate *)selectedDate
{
    _selectedDate = selectedDate;

    for (id subview in self.datesScrollView.subviews) {
        if ([subview isKindOfClass:[DIDatepickerDateView class]]) {
            DIDatepickerDateView *dateView = (DIDatepickerDateView *)subview;
            dateView.isSelected = [dateView.date isEqualToDate:selectedDate];
        }
    }

    [self updateSelectedDatePosition];

    [self sendActionsForControlEvents:UIControlEventValueChanged];
}

- (UIScrollView *)datesScrollView
{
    if (!_datesScrollView) {
        _datesScrollView = [[UIScrollView alloc] initWithFrame:self.bounds];
        _datesScrollView.showsHorizontalScrollIndicator = NO;
        _datesScrollView.autoresizingMask = self.autoresizingMask;
        [self addSubview:_datesScrollView];
    }
    return _datesScrollView;
}

- (void)setSelectedDateBottomLineColor:(UIColor *)selectedDateBottomLineColor
{
    _selectedDateBottomLineColor = selectedDateBottomLineColor;

    for (id subview in self.datesScrollView.subviews) {
        if ([subview isKindOfClass:[DIDatepickerDateView class]]) {
            DIDatepickerDateView *dateView = (DIDatepickerDateView *)subview;
            [dateView setItemSelectionColor:selectedDateBottomLineColor];
        }
    }
}


#pragma mark Public methods

- (void)fillDatesFromCurrentDate:(NSInteger)nextDatesCount
{
    NSAssert(nextDatesCount < 1000, @"Too much dates");

    NSMutableArray *dates = [[NSMutableArray alloc] init];
    for (NSInteger day = 0; day < nextDatesCount; day++) {
        [dates addObject:[NSDate dateWithTimeIntervalSinceNow:day * kSecondsInDay]];
    }

    self.dates = dates;
}

- (void)fillDatesFromDate:(NSDate *)fromDate numberOfDays:(NSInteger)nextDatesCount
{
    NSAssert(nextDatesCount < 1000, @"Too much dates");

    NSMutableArray *dates = [[NSMutableArray alloc] init];

    for (NSInteger day = 0; day < nextDatesCount; day++)
    {
        [dates addObject:[fromDate dateByAddingTimeInterval:day * kSecondsInDay]];
    }

    NSMutableArray *existingDates = [NSMutableArray arrayWithArray:self.dates];
    [dates addObjectsFromArray:existingDates];

    self.dates = dates;
}

- (void)fillDatesSinceDate:(NSDate *)sinceDate numberOfDays:(NSInteger)nextDatesCount {
    NSMutableArray *dates = [[NSMutableArray alloc] init];

    for (NSInteger day = 1; day < nextDatesCount; day++)
    {
        [dates addObject:[sinceDate dateByAddingTimeInterval:-(day * kSecondsInDay)]];
    }
    NSMutableArray *existingDates = [NSMutableArray arrayWithArray:self.dates];
    [dates addObjectsFromArray:existingDates];

    self.dates = dates;
}

- (void)selectDateClosestToToday{
  double smallestDifference = DBL_MAX; // thanks bgfriend0
  NSDate *closestDate = nil;

  for (NSDate *date in self.dates) {
      if (ABS([date timeIntervalSinceNow]) < smallestDifference) {
          smallestDifference = ABS([date timeIntervalSinceNow]);
          closestDate = date;
      }
  }
  
  self.selectedDate = closestDate;
}

- (void)selectDate:(NSDate *)date
{
    NSAssert([self.dates indexOfObject:date] != NSNotFound, @"Date not found in dates array");

    self.selectedDate = date;
}

- (void)selectDateAtIndex:(NSUInteger)index
{
    NSAssert(index < self.dates.count, @"Index too big");

    self.selectedDate = self.dates[index];
}

#pragma mark Private methods

- (void)drawRect:(CGRect)rect
{
    [super drawRect:rect];

    // draw bottom line
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetStrokeColorWithColor(context, self.bottomLineColor.CGColor);
    CGContextSetLineWidth(context, .5);
    CGContextMoveToPoint(context, 0, rect.size.height - .5);
    CGContextAddLineToPoint(context, rect.size.width, rect.size.height - .5);
    CGContextStrokePath(context);
}

- (void)updateDatesView
{
    [self.datesScrollView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];

    CGFloat currentItemXPosition = kDIDatepickerSpaceBetweenItems;
    for (NSDate *date in self.dates) {
        DIDatepickerDateView *dateView = [[DIDatepickerDateView alloc] initWithFrame:CGRectMake(currentItemXPosition, 0, kDIDatepickerItemWidth, self.frame.size.height)];
        dateView.date = date;
        dateView.selected = [date isEqualToDate:self.selectedDate];
        [dateView setItemSelectionColor:self.selectedDateBottomLineColor];
        [dateView addTarget:self action:@selector(updateSelectedDate:) forControlEvents:UIControlEventValueChanged];

        [self.datesScrollView addSubview:dateView];

        currentItemXPosition += kDIDatepickerItemWidth + kDIDatepickerSpaceBetweenItems;
    }

    self.datesScrollView.contentSize = CGSizeMake(currentItemXPosition, self.frame.size.height);
}

- (void)updateSelectedDate:(DIDatepickerDateView *)dateView
{
    self.selectedDate = dateView.date;
}

-(void)layoutSubviews {
  [super layoutSubviews];
  [self updateSelectedDatePosition];
}

- (void)updateSelectedDatePosition
{
    NSUInteger itemIndex = [self.dates indexOfObject:self.selectedDate];

    CGSize itemSize = CGSizeMake(kDIDatepickerItemWidth + kDIDatepickerSpaceBetweenItems, self.frame.size.height);
    CGFloat itemOffset = itemSize.width * itemIndex - (self.frame.size.width - (kDIDatepickerItemWidth + 2 * kDIDatepickerSpaceBetweenItems)) / 2;

    itemOffset = MAX(0, MIN(self.datesScrollView.contentSize.width - (self.frame.size.width ), itemOffset));

    [self.datesScrollView setContentOffset:CGPointMake(itemOffset, 0) animated:YES];
}

@end
