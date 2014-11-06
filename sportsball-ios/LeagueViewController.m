//
//  LeagueViewController.m
//  sportsball-ios
//
//  Created by Mike Silvis on 11/6/14.
//  Copyright (c) 2014 Mike Silvis. All rights reserved.
//

#import "LeagueViewController.h"
#import "ScoreIndexView.h"

@implementation LeagueViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor blackColor];

    self.paginalTableView = [[APPaginalTableView alloc] initWithFrame:self.view.bounds];
    
    self.paginalTableView.dataSource = self;
    self.paginalTableView.delegate = self;

    [self.view addSubview:self.paginalTableView];
}

- (NSUInteger)numberOfElementsInPaginalTableView:(APPaginalTableView *)managerView
{
    return 3;
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
    UILabel *labelCollapsed = [[UILabel alloc] initWithFrame:CGRectMake(10.f, 0.f, 150.f, 50.f)];
    labelCollapsed.text = [NSString stringWithFormat:@"Collapsed View %lu", (unsigned long)index];
    
    UIView *collapsedView = [[UIView alloc] initWithFrame:CGRectMake(0.f, 0.f, self.view.bounds.size.width, 80.f)];
    collapsedView.backgroundColor = [UIColor colorWithRed:0.f + (index * 0.1f) green:0.3f blue:0.7f alpha:1.f];
    collapsedView.autoresizingMask = UIViewAutoresizingFlexibleHeight;
    [collapsedView addSubview:labelCollapsed];
    
    return collapsedView;
}

- (UIView *)createExpandedViewAtIndex:(NSUInteger)index
{
  ScoreIndexView *scoreIndex = [[[NSBundle mainBundle] loadNibNamed:@"ScoreIndexView" owner:nil options:nil] lastObject];
  scoreIndex.league = @"NHL";

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

@end
