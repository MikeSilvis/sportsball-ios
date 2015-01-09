//
//  SportsBallModalViewController.m
//  sportsball-ios
//
//  Created by Mike Silvis on 1/8/15.
//  Copyright (c) 2015 Mike Silvis. All rights reserved.
//

#import "SportsBallModalViewController.h"

@interface SportsBallModalViewController ()

@end

@implementation SportsBallModalViewController

- (void)viewDidLoad {
  [super viewDidLoad];

  self.view.backgroundColor = [UIColor clearColor];

  // Blur effect
  UIBlurEffect *blur = [UIBlurEffect effectWithStyle:UIBlurEffectStyleDark];
  self.blurView = [[UIVisualEffectView alloc] initWithEffect:blur];
  [self.view addSubview:self.blurView];
  [self.view sendSubviewToBack:self.blurView];
}

-(void)viewWillLayoutSubviews {
  [super viewWillLayoutSubviews];

  self.blurView.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
}

@end