//
//  SBWebViewController.m
//  sportsball-ios
//
//  Created by Mike Silvis on 2/21/15.
//  Copyright (c) 2015 Mike Silvis. All rights reserved.
//

#import "SBWebViewController.h"
#import "UIImage+FontAwesome.h"

@interface SBWebViewController ()

@property BOOL didStartLoadingAlready;

@end

@implementation SBWebViewController

- (void)viewDidLoad {
  [super viewDidLoad];

  // Back Icon
  CGFloat iconSize = 25;
  FAKFontAwesome *backIcon = [FAKFontAwesome chevronLeftIconWithSize:iconSize];
  [self.backButton setImage:[UIImage imageWithFontAwesomeIcon:backIcon andSize:iconSize andColor:@"#fff"] forState:UIControlStateNormal];
  [self.backButton setTitle:@"" forState:UIControlStateNormal];
  [self.backButton addTarget:self action:@selector(closeModal) forControlEvents:UIControlEventTouchDown];
  [self.backButton setTintColor:[UIColor whiteColor]];
  [self.backButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
}

- (void)setUrl:(NSURL *)url {
  _url = url;

  self.didStartLoadingAlready = NO;

  NSURLRequest *requestObj = [NSURLRequest requestWithURL:self.url];
  [self.webView loadRequest:requestObj];
}

- (void)closeModal {
  [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - Web View

- (void)webViewDidStartLoad:(UIWebView *)webView {
  [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;

  if (!self.didStartLoadingAlready) {
    [self didStartLoading];
  }
}

- (void)webViewDidFinishLoad:(UIWebView *)webView {
  [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
  [self didEndLoading];
}

@end
