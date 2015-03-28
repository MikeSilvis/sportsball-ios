//
//  SBTabViewSegue.m
//  sportsball-ios
//
//  Created by Mike Silvis on 3/28/15.
//  Copyright (c) 2015 Mike Silvis. All rights reserved.
//

#import "SBTabViewSegue.h"

@implementation SBTabViewSegue

- (void)perform {
  UIViewController *src = (UIViewController *) self.sourceViewController;
  UIViewController *dst = (UIViewController *) self.destinationViewController;

  [src.navigationController pushViewController:dst animated:NO];
}

@end
