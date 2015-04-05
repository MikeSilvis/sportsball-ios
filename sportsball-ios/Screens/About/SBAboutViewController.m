//
//  SBAboutViewController.m
//  sportsball-ios
//
//  Created by Mike Silvis on 2/27/15.
//  Copyright (c) 2015 Mike Silvis. All rights reserved.
//

#import "SBAboutViewController.h"
#import "UIImage+FontAwesome.h"
#import "SBAboutTableViewCell.h"
#import "SBUser.h"
#import "SBConstants.h"

@implementation SBAboutViewController

static NSString * const kAboutInfoCell = @"kAboutInfoCell";

static const NSInteger kEmailUsLocation = 0;
static const NSInteger kRateUsLocation  = 1;

- (void)viewDidLoad {
  [super viewDidLoad];

  // Close Icon
  CGFloat iconSize = 25;
  FAKFontAwesome *closeIcon = [FAKFontAwesome timesIconWithSize:iconSize];
  [self.closeButton setImage:[UIImage imageWithFontAwesomeIcon:closeIcon andSize:iconSize andColor:@"#fff"] forState:UIControlStateNormal];
  [self.closeButton setTitle:@"" forState:UIControlStateNormal];
  [self.closeButton addTarget:self action:@selector(closeModal) forControlEvents:UIControlEventTouchDown];


  self.tableView.backgroundColor = [UIColor clearColor];
  self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
}

- (void)closeModal {
  [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - Table view

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  SBAboutTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kAboutInfoCell];

  NSString *textForLabel = nil;
  if (indexPath.row == kEmailUsLocation) {
    textForLabel = @"Email us feedback";
  }
  else if (indexPath.row == kRateUsLocation) {
    textForLabel = @"Rate us in the App Store";
  }

  cell.contentLabel.text = textForLabel;

  return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
  return 2;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
  return 44;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
  if (indexPath.row == kEmailUsLocation) {
    [self feedbackClicked:indexPath];
  }
  else if (indexPath.row == kRateUsLocation) {
    NSString *appStoreURL = [[SBConstants sharedInstance] getSecretValueFrom:@"APP_STORE_URL"];
    [[UIApplication sharedApplication] openURL: [NSURL URLWithString:appStoreURL]];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
  }
}

- (void)feedbackClicked:(NSIndexPath *)indexPath {
  if ([MFMailComposeViewController canSendMail]) {
    NSString *messageBody = [NSString stringWithFormat:@"\nUser ID: %@", [SBUser currentUser].currentPfUser.objectId];

    MFMailComposeViewController *mailCont = [[MFMailComposeViewController alloc] init];
    mailCont.mailComposeDelegate = self;

    [mailCont setSubject:@"Hello!"];
    [mailCont setToRecipients:@[@"mike@jumbotron.io"]];
    [mailCont setMessageBody:messageBody isHTML:NO];

    [self presentViewController:mailCont animated:YES completion:^{
      [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
      [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
    }];
  }
}

- (void)mailComposeController:(MFMailComposeViewController*)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError*)error {
  [controller dismissViewControllerAnimated:YES completion:nil];
}

@end