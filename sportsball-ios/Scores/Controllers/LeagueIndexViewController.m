//
//  LeagueViewController.m
//  sportsball-ios
//
//  Created by Mike Silvis on 11/6/14.
//  Copyright (c) 2014 Mike Silvis. All rights reserved.
//

#import "LeagueIndexViewController.h"
#import "LeagueIndexHeader.h"
#import "League.h"
#import "XHRealTimeBlur.h"
#import <QuartzCore/QuartzCore.h>
#import "UIImage+FontAwesome.h"

@implementation LeagueIndexViewController

- (void)viewDidLoad {
  [super viewDidLoad];

  self.leagues = [League supportedLeagues];
  self.scoreViews = [NSMutableArray array];

  self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"background"]];

  // Create the table list
  self.paginalTableView = [[APPaginalTableView alloc] initWithFrame:self.view.bounds];
  self.paginalTableView.dataSource = self;
  self.paginalTableView.delegate = self;
  self.paginalTableView.tableView.separatorColor = [UIColor whiteColor];
  self.paginalTableView.tableView.separatorInset = UIEdgeInsetsZero;
  self.paginalTableView.tableView.layoutMargins = UIEdgeInsetsZero;
  self.paginalTableView.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
  self.paginalTableView.tableView.backgroundColor = [UIColor clearColor];
  self.paginalTableView.backgroundColor = [UIColor clearColor];
  [self.view insertSubview:self.paginalTableView belowSubview:self.toolBar];

  // Create the page control
  self.pageControl = [[UIPageControl alloc] init];
  self.pageControl.numberOfPages = self.leagues.count;
  self.pageControl.currentPage = 1;
  self.pageControl.frame = CGRectMake(0, 5, 200, 50);
  [self.pageControl sizeToFit];
  CGRect f = self.pageControl.frame;
  f.origin.x = (self.view.bounds.size.width - self.pageControl.bounds.size.width) / 2;
  self.pageControl.frame = f;
  self.pageControl.hidden = YES;
  [self.view addSubview:self.pageControl];

//  [self openScoresAtIndex:0 animated:NO];

  CGFloat iconSize = 25;
  FAKFontAwesome *hamburgerIcon = [FAKFontAwesome barsIconWithSize:iconSize];
  self.hamburgerButton.image = [UIImage imageWithFontAwesomeIcon:hamburgerIcon andSize:iconSize andColor:@"#fff"];

  self.toolBar.backgroundColor = [UIColor clearColor];
  [self.toolBar setBackgroundImage:[UIImage new]
                forToolbarPosition:UIToolbarPositionAny
                        barMetrics:UIBarMetricsDefault];
  self.toolBar.clipsToBounds = YES;

  self.toolBar.hidden = YES;

  [[NSNotificationCenter defaultCenter] addObserver:self
                                           selector:@selector(stopTimer)
                                               name:UIApplicationDidEnterBackgroundNotification
                                             object:nil];

  [[NSNotificationCenter defaultCenter] addObserver:self
                                           selector:@selector(startTimer)
                                               name:UIApplicationDidBecomeActiveNotification
                                             object:nil];
}

-(void)didStartLoading {
  [self.view showRealTimeBlurWithBlurStyle:XHBlurStyleTranslucent];

  if (!self.activityView) {
    self.activityView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    self.activityView.center = CGPointMake(50, 50);
    self.activityView.frame = self.view.bounds;
    self.activityView.hidesWhenStopped = YES;
    self.activityView.transform = CGAffineTransformMakeScale(2, 2);
    [self.activityView startAnimating];
  }

  [self.view addSubview:self.activityView];
  self.activityView.hidden = NO;
}

-(void)didEndLoading {
  [self.view disMissRealTimeBlur];

  if (self.activityView) {
    self.activityView.hidden = YES;
    [self.activityView removeFromSuperview];
  }
}

-(void)paginalTableView:(APPaginalTableView *)paginalTableView didChangeIndex:(NSUInteger)index {
  [self stopTimer];
  [self startTimer];
}

-(void)startTimer {
  if (self.scoreViews.count >= self.paginalTableView.indexOpenedElement) {
    self.pageControl.currentPage = self.paginalTableView.indexOpenedElement;

    [self.scoreViews[self.paginalTableView.indexOpenedElement] startTimer];
  }
}

-(void)stopTimer {
  for (ScoreIndexView *view in self.scoreViews) {
    [view cancelTimer];
  }
}

- (IBAction)didRequestClose:(id)sender {
  self.pageControl.hidden = YES;
  self.toolBar.hidden = YES;
  [self.paginalTableView closeElementWithCompletion:nil animated:YES];
}

-(void)openScoresAtIndex:(NSUInteger)index animated:(BOOL)animated {
  [self.paginalTableView openElementAtIndex:index completion:^(BOOL completed) {
    if (completed) {
      self.pageControl.hidden = NO;
      self.toolBar.hidden = NO;
    }
  } animated:animated];
}

- (NSUInteger)numberOfElementsInPaginalTableView:(APPaginalTableView *)managerView {
    return self.leagues.count;
}

- (UIView *)paginalTableView:(APPaginalTableView *)paginalTableView collapsedViewAtIndex:(NSUInteger)index
{
    UIView *collapsedView = [self createCollapsedViewAtIndex:index];
    return collapsedView;
}

- (UIView *)paginalTableView:(APPaginalTableView *)paginalTableView expandedViewAtIndex:(NSUInteger)index
{
    UIView *expandedView = [self createExpandedViewAtIndex:index];
    return expandedView;
}

#pragma mark - APPaginalTableViewDelegate

- (BOOL)paginalTableView:(APPaginalTableView *)managerView
      openElementAtIndex:(NSUInteger)index
      onChangeHeightFrom:(CGFloat)initialHeight
                toHeight:(CGFloat)finalHeight
{
  BOOL open = _paginalTableView.isExpandedState;
  APPaginalTableViewElement *element = [managerView elementAtIndex:index];

  // Open
  if (initialHeight > finalHeight) {
    open = finalHeight > element.expandedHeight * 0.8f;
  }
  // Close
  else if (initialHeight < finalHeight) {
    open = finalHeight > element.expandedHeight * 0.2f;
  }

  ScoreIndexView *scoreView = self.scoreViews[index];
  [scoreView cancelTimer];
  self.pageControl.hidden = YES;
  self.toolBar.hidden = YES;

  return open;
}

- (void)paginalTableView:(APPaginalTableView *)paginalTableView didSelectRowAtIndex:(NSUInteger)index {
  [self openScoresAtIndex:index animated:YES];
}

- (UIView *)createCollapsedViewAtIndex:(NSUInteger)index
{
  CGFloat cellHeight = 100;

  LeagueIndexHeader *leagueHeader = [[[NSBundle mainBundle] loadNibNamed:@"LeagueIndexHeader" owner:nil options:nil] lastObject];
  leagueHeader.frame = CGRectMake(0, 0, self.view.bounds.size.width, cellHeight);
  leagueHeader.league = self.leagues[index];

  return leagueHeader;
}

- (UIView *)createExpandedViewAtIndex:(NSUInteger)index
{
  ScoreIndexView *scoreIndex = [[[NSBundle mainBundle] loadNibNamed:@"ScoreIndexView" owner:nil options:nil] lastObject];
  scoreIndex.league = self.leagues[index];
  scoreIndex.frame = self.view.bounds;
  scoreIndex.delegate = self;
  [self.scoreViews addObject:scoreIndex];

  return scoreIndex;
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}


@end
