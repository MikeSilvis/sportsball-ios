//
//  LeagueViewController.m
//  sportsball-ios
//
//  Created by Mike Silvis on 11/6/14.
//  Copyright (c) 2014 Mike Silvis. All rights reserved.
//

#import "LeagueViewController.h"
#import "ScoreIndexView.h"
#import "LeagueIndexHeader.h"
#import "League.h"

@implementation LeagueViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor blackColor];

    self.leagues = [League supportedLeagues];

    self.paginalTableView = [[APPaginalTableView alloc] initWithFrame:self.view.bounds];
    
    self.paginalTableView.dataSource = self;
    self.paginalTableView.delegate = self;
    self.paginalTableView.tableView.separatorColor = [UIColor whiteColor];
    self.paginalTableView.tableView.separatorInset = UIEdgeInsetsZero;
    self.paginalTableView.tableView.layoutMargins = UIEdgeInsetsZero;
    self.paginalTableView.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];

    [self.view addSubview:self.paginalTableView];

    [self.paginalTableView openElementAtIndex:0 completion:nil animated:NO];
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
    
    if (initialHeight > finalHeight) { //open
        open = finalHeight > element.expandedHeight * 0.8f;
    }
    else if (initialHeight < finalHeight) { //close
        open = finalHeight > element.expandedHeight * 0.2f;
    }
    return open;
}

- (void)paginalTableView:(APPaginalTableView *)paginalTableView didSelectRowAtIndex:(NSUInteger)index
{
    [self.paginalTableView openElementAtIndex:index completion:nil animated:YES];
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

  return scoreIndex;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}


@end
