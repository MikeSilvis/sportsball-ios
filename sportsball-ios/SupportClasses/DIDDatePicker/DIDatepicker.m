//
//  Created by Dmitry Ivanenko on 14.04.14.
//  Copyright (c) 2014 Dmitry Ivanenko. All rights reserved.
//

#import "DIDatepicker.h"
#import "DIDatepickerDateView.h"

const CGFloat kDIDatepickerHeight = 60.;
const CGFloat kDIDatepickerSpaceBetweenItems = 15.;
NSString * const kDIDatepickerCellIndentifier = @"kDIDatepickerCellIndentifier";

@interface DIDatepicker (){
  NSIndexPath *selectedIndexPath;
}

@property (strong, nonatomic) UICollectionView *datesCollectionView;
@property (strong, nonatomic, readwrite) NSDate *selectedDate;
@property BOOL isAnimated;

@end


@implementation DIDatepicker

- (void)awakeFromNib
{
  [self setupViews];
}

- (id)initWithFrame:(CGRect)frame
{
  if(self = [super initWithFrame:frame]){
    [self setupViews];
    self.isAnimated = YES;
  }

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
  _dates = dates;

  [self.datesCollectionView reloadData];

  self.selectedDate = nil;
}

- (void)setSelectedDate:(NSDate *)selectedDate
{
  _selectedDate = selectedDate;

  NSIndexPath *selectedCellIndexPath = [NSIndexPath indexPathForItem:[self.dates indexOfObject:selectedDate] inSection:0];
  [self.datesCollectionView deselectItemAtIndexPath:selectedIndexPath animated:NO];
  [self.datesCollectionView selectItemAtIndexPath:selectedCellIndexPath animated:self.isAnimated scrollPosition:UICollectionViewScrollPositionCenteredHorizontally];

  selectedIndexPath = selectedCellIndexPath;

  [self sendActionsForControlEvents:UIControlEventValueChanged];
}

- (UICollectionView *)datesCollectionView
{
  if (!_datesCollectionView) {
    UICollectionViewFlowLayout *collectionViewLayout = [[UICollectionViewFlowLayout alloc] init];
    [collectionViewLayout setItemSize:CGSizeMake(kDIDatepickerItemWidth, CGRectGetHeight(self.bounds))];
    [collectionViewLayout setScrollDirection:UICollectionViewScrollDirectionHorizontal];
    [collectionViewLayout setSectionInset:UIEdgeInsetsMake(0, kDIDatepickerSpaceBetweenItems, 0, kDIDatepickerSpaceBetweenItems)];
    [collectionViewLayout setMinimumLineSpacing:kDIDatepickerSpaceBetweenItems];

    _datesCollectionView = [[UICollectionView alloc] initWithFrame:self.bounds collectionViewLayout:collectionViewLayout];
    [_datesCollectionView registerClass:[DIDatepickerCell class] forCellWithReuseIdentifier:kDIDatepickerCellIndentifier];
    [_datesCollectionView setBackgroundColor:[UIColor clearColor]];
    [_datesCollectionView setShowsHorizontalScrollIndicator:NO];
    [_datesCollectionView setAllowsMultipleSelection:YES];
    _datesCollectionView.dataSource = self;
    _datesCollectionView.delegate = self;
    [self addSubview:_datesCollectionView];
  }
  return _datesCollectionView;
}

- (void)setSelectedDateBottomLineColor:(UIColor *)selectedDateBottomLineColor
{
  _selectedDateBottomLineColor = selectedDateBottomLineColor;

  [self.datesCollectionView.indexPathsForSelectedItems enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        DIDatepickerCell *selectedCell = (DIDatepickerCell *)[self.datesCollectionView cellForItemAtIndexPath:obj];
        selectedCell.itemSelectionColor = _selectedDateBottomLineColor;
  }];
}

#pragma mark Public methods

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

- (void)selectDateClosestToToday{
  double smallestDifference = DBL_MAX;
  NSDate *closestDate = nil;

  NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
  [dateFormat setDateFormat:@"yyyy-MM-dd"];
  NSString *today = [dateFormat stringFromDate:[NSDate date]];

  for (NSDate *date in self.dates) {
      if ([today isEqualToString:[dateFormat stringFromDate:date]]) {
        closestDate = date;
        break;
      }
      else if (ABS([date timeIntervalSinceNow]) < smallestDifference) {
          smallestDifference = ABS([date timeIntervalSinceNow]);
          closestDate = date;
      }
  }

  self.isAnimated = NO;
  self.selectedDate = closestDate;
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

-(void)layoutSubviews {
  [super layoutSubviews];

  CGRect f = self.datesCollectionView.frame;
  f.size.width = self.bounds.size.width;
  self.datesCollectionView.frame = f;
}

#pragma mark - UICollectionView Delegate

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
  return 1;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
  return  [self.dates count];
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
  DIDatepickerCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kDIDatepickerCellIndentifier forIndexPath:indexPath];
  cell.date = [self.dates objectAtIndex:indexPath.item];
  cell.itemSelectionColor = _selectedDateBottomLineColor;
  return cell;
}

- (BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
  return ![indexPath isEqual:selectedIndexPath];
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
  [self.datesCollectionView scrollToItemAtIndexPath:indexPath atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:YES];
  _selectedDate = [self.dates objectAtIndex:indexPath.item];

  [collectionView deselectItemAtIndexPath:selectedIndexPath animated:NO];
  self.isAnimated = YES;
  selectedIndexPath = indexPath;
  [self sendActionsForControlEvents:UIControlEventValueChanged];
}


@end
