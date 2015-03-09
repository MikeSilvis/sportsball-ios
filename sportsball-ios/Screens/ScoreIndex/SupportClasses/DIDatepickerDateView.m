//
//  Created by Dmitry Ivanenko on 15.04.14.
//  Copyright (c) 2014 Dmitry Ivanenko. All rights reserved.
//

#import "DIDatepickerDateView.h"


const CGFloat kDIDatepickerItemWidth = 46.;
const CGFloat kDIDatepickerSelectionLineWidth = 51.;


@interface DIDatepickerDateView ()

@property (strong, nonatomic) UILabel *dateLabel;
@property (nonatomic, strong) UIView *selectionView;

@end


@implementation DIDatepickerDateView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (!self) return nil;

    [self setupViews];

    return self;
}

- (void)setupViews
{
    [self addTarget:self action:@selector(dateWasSelected) forControlEvents:UIControlEventTouchUpInside];
}

- (void)setDate:(NSDate *)date
{
    _date = date;

    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];

    [dateFormatter setDateFormat:@"dd"];
    NSString *dayFormattedString = [dateFormatter stringFromDate:date];

    [dateFormatter setDateFormat:@"EEE"];
    NSString *dayInWeekFormattedString = [dateFormatter stringFromDate:date];

    [dateFormatter setDateFormat:@"MMMM"];
    NSString *monthFormattedString = [[dateFormatter stringFromDate:date] uppercaseString];

    NSString *overallFormattedString = [NSString stringWithFormat:@"%@\n%@ %@", monthFormattedString, dayFormattedString, [dayInWeekFormattedString uppercaseString]];
    NSMutableAttributedString *dateString = [[NSMutableAttributedString alloc] initWithString:overallFormattedString];

    [dateString addAttributes:@{
                                NSFontAttributeName: [UIFont fontWithName:@"Avenir-Light" size:8],
                                NSForegroundColorAttributeName: [UIColor colorWithRed:153./255. green:153./255. blue:153./255. alpha:1.]
                                }
                        range:NSMakeRange(0, monthFormattedString.length)];

    [dateString addAttributes:@{
                                NSFontAttributeName: [UIFont fontWithName:@"Avenir-Light" size:20],
                                NSForegroundColorAttributeName: [UIColor whiteColor]
                                }
                        range:NSMakeRange(monthFormattedString.length + 1, dayFormattedString.length)];

    [dateString addAttributes:@{
                                NSFontAttributeName: [UIFont fontWithName:@"Avenir-Medium" size:8],
                                NSForegroundColorAttributeName: [UIColor whiteColor]
                                }
                        range:NSMakeRange(dateString.string.length - dayInWeekFormattedString.length, dayInWeekFormattedString.length)];

    self.dateLabel.attributedText = dateString;
}

- (void)setIsSelected:(BOOL)isSelected
{
    _isSelected = isSelected;

    self.selectionView.alpha = (int)_isSelected;
}

- (UILabel *)dateLabel
{
    if (!_dateLabel) {
        _dateLabel = [[UILabel alloc] initWithFrame:self.bounds];
        _dateLabel.numberOfLines = 2;
        _dateLabel.textAlignment = NSTextAlignmentCenter;
        [self addSubview:_dateLabel];
    }

    return _dateLabel;
}

- (UIView *)selectionView
{
    if (!_selectionView) {
        _selectionView = [[UIView alloc] initWithFrame:CGRectMake((self.frame.size.width - 51) / 2, (self.frame.size.height - 3), 51, 3)];
        _selectionView.alpha = 0;
        _selectionView.backgroundColor = [UIColor colorWithRed:242./255. green:93./255. blue:28./255. alpha:1.];
        [self addSubview:_selectionView];
    }

    return _selectionView;
}

- (void)setItemSelectionColor:(UIColor *)itemSelectionColor
{
    self.selectionView.backgroundColor = itemSelectionColor;
}

- (void)setHighlighted:(BOOL)highlighted
{
    [super setHighlighted:highlighted];
    if (highlighted) {
        self.selectionView.alpha = self.isSelected ? 1 : .5;
    } else {
        self.selectionView.alpha = self.isSelected ? 1 : 0;
    }
}


#pragma mark Other methods

- (void)dateWasSelected
{
    self.isSelected = YES;

    [self sendActionsForControlEvents:UIControlEventValueChanged];
}

@end
