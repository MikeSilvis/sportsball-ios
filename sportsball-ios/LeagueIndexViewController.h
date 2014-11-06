//
//  LeagueViewController.h
//  sportsball-ios
//
//  Created by Mike Silvis on 11/6/14.
//  Copyright (c) 2014 Mike Silvis. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "APPaginalTableView.h"

@interface LeagueIndexViewController : UIViewController <APPaginalTableViewDataSource, APPaginalTableViewDelegate>

@property (nonatomic, retain) APPaginalTableView *paginalTableView;
@property (nonatomic, retain) NSArray *leagues;

//    [self.paginalTableView openElementAtIndex:0 completion:nil animated:NO];

@end
