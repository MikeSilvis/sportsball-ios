//
//  SBWebViewController.h
//  sportsball-ios
//
//  Created by Mike Silvis on 2/21/15.
//  Copyright (c) 2015 Mike Silvis. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SBModalViewController.h"

@interface SBWebViewController : SBModalViewController <UIWebViewDelegate>

@property (nonatomic, strong) NSURL *url;
@property (weak, nonatomic) IBOutlet UIButton *backButton;
@property (weak, nonatomic) IBOutlet UIWebView *webView;

@end
