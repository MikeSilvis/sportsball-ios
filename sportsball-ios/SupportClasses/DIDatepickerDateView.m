//
//  Created by Dmitry Ivanenko on 15.04.14.
//  Copyright (c) 2014 Dmitry Ivanenko. All rights reserved.
//

#import "DIDatepickerDateView.h"


const CGFloat kDIDatepickerItemWidth = 46.;
const CGFloat kDIDatepickerSelectionLineWidth = 51.;


@interface DIDatepickerCell ()

  @property (strong, nonatomic) UILabel *dateLabel;
  @property (nonatomic, strong) UIView *selectionView;
  @property (nonatomic, strong) NSDateFormatter *dateFormatter;

  @end


  @implementation DIDatepickerCell

  - (id)initWithFrame:(CGRect)frame
{
  if(self = [super initWithFrame:frame]){
        [self setBackgroundColor:[UIColor clearColor]];
  }

  return self;
}

- (void)prepareForReuse
{
  [self setSelected:NO];
  self.selectionView.alpha = 0.0f;
}

#pragma mark - Setters

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
                                NSForegroundColorAttributeName: [UIColor whiteColor]
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

- (void)setItemSelectionColor:(UIColor *)itemSelectionColor
{
  self.selectionView.backgroundColor = itemSelectionColor;
}

- (void)setHighlighted:(BOOL)highlighted
{
  [super setHighlighted:highlighted];

  self.selectionView.hidden = NO;
  if (highlighted) {
    self.selectionView.alpha = self.isSelected ? 1 : .5;
  } else {
    self.selectionView.alpha = self.isSelected ? 1 : 0;
  }
}

- (void)setSelected:(BOOL)selected
{
  [super setSelected:selected];
  self.selectionView.alpha = (selected)?1.0f:0.0f;
}

#pragma mark - Getters

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
    _selectionView = [[UIView alloc] initWithFrame:CGRectMake((CGRectGetWidth(self.frame) - 51) / 2, CGRectGetHeight(self.frame) - 3, 51, 3)];
    _selectionView.alpha = 0.0f;
    _selectionView.backgroundColor = [UIColor colorWithRed:242./255. green:93./255. blue:28./255. alpha:1.];
    [self addSubview:_selectionView];
  }

  return _selectionView;
}

- (NSDateFormatter *)dateFormatter
{
  if(!_dateFormatter){
    _dateFormatter = [[NSDateFormatter alloc] init];
  }

  return _dateFormatter;
}

@end
