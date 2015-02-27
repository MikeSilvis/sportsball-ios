//
//  SBAboutViewController.h
//  sportsball-ios
//
//  Created by Mike Silvis on 2/27/15.
//  Copyright (c) 2015 Mike Silvis. All rights reserved.
//

#import "SBModalViewController.h"
#import <MessageUI/MessageUI.h>
#import <MessageUI/MFMailComposeViewController.h>

@interface SBAboutViewController : SBModalViewController <UITableViewDataSource, UITableViewDelegate, MFMailComposeViewControllerDelegate>

@property (weak, nonatomic) IBOutlet UIButton *closeButton;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end
