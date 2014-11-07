//
//  LeagueViewController.m
//  sportsball-ios
//
//  Created by Mike Silvis on 11/6/14.
//  Copyright (c) 2014 Mike Silvis. All rights reserved.
//

#import "LeagueIndexViewController.h"
#import "ScoreIndexView.h"
#import "LeagueIndexHeader.h"
#import "League.h"

@implementation LeagueIndexViewController

- (void)viewDidLoad {
  [super viewDidLoad];

  self.leagues = [League supportedLeagues];
  self.scoreViews = [NSMutableArray array];

  self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"rabble"]];

  self.paginalTableView = [[APPaginalTableView alloc] initWithFrame:self.view.bounds];
  
  self.paginalTableView.dataSource = self;
  self.paginalTableView.delegate = self;
  self.paginalTableView.tableView.separatorColor = [UIColor whiteColor];
  self.paginalTableView.tableView.separatorInset = UIEdgeInsetsZero;
  self.paginalTableView.tableView.layoutMargins = UIEdgeInsetsZero;
  self.paginalTableView.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];

  [self.view addSubview:self.paginalTableView];

//  [self openScoresAtIndex:0 animated:NO];

  [[NSNotificationCenter defaultCenter] addObserver:self
                                           selector:@selector(stopTimer)
                                               name:UIApplicationDidEnterBackgroundNotification
                                             object:nil];

  [[NSNotificationCenter defaultCenter] addObserver:self
                                           selector:@selector(startTimer)
                                               name:UIApplicationDidBecomeActiveNotification
                                             object:nil];
}

-(void)paginalTableView:(APPaginalTableView *)paginalTableView didChangeIndex:(NSUInteger)index {
  [self stopTimer];
  [self startTimer];
}

// Start Current timer
-(void)startTimer {
  if (self.scoreViews.count >= self.paginalTableView.indexOpenedElement) {
    [self.scoreViews[self.paginalTableView.indexOpenedElement] startTimer];
  }
}

// Cancel all timers
-(void)stopTimer {
  for (ScoreIndexView *view in self.scoreViews) {
    [view cancelTimer];
  }
}

-(void)openScoresAtIndex:(NSUInteger)index animated:(BOOL)animated {
  [self.paginalTableView openElementAtIndex:index completion:nil animated:animated];
}

- (NSUInteger)numberOfElementsInPaginalTableView:(APPaginalTableView *)managerView
{
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

  return open;
}

- (void)paginalTableView:(APPaginalTableView *)paginalTableView didSelectRowAtIndex:(NSUInteger)index
{
  [self openScoresAtIndex:index animated:YES];
}

#pragma mark - Internal

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
  [self.scoreViews addObject:scoreIndex];

  return scoreIndex;
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}


@end
