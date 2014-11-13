//
//  LeagueViewController.h
//  sportsball-ios
//
//  Created by Mike Silvis on 11/6/14.
//  Copyright (c) 2014 Mike Silvis. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "APPaginalTableView.h"
#import "ScoreIndexView.h"

@interface LeagueIndexViewController : UIViewController <APPaginalTableViewDataSource, APPaginalTableViewDelegate, ScoreIndexViewDelegate>

@property (nonatomic, retain) APPaginalTableView *paginalTableView;
@property (nonatomic, retain) UIPageControl *pageControl;
@property (nonatomic, retain) NSArray *leagues;
@property (nonatomic, retain) NSMutableArray *scoreViews;
@property (nonatomic, retain) UIActivityIndicatorView *activityView;
@property (weak, nonatomic) IBOutlet UIToolbar *toolBar;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *hamburgerButton;
- (IBAction)didRequestClose:(id)sender;

-(void)openScoresAtIndex:(NSUInteger)index animated:(BOOL)animated;

@end
