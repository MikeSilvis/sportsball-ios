//
//  AppDelegate.m
//  sportsball-ios
//
//  Created by Mike Silvis on 10/31/14.
//  Copyright (c) 2014 Mike Silvis. All rights reserved.
//

#import "AppDelegate.h"
#import <Fabric/Fabric.h>
#import <Crashlytics/Crashlytics.h>
#import <AFNetworking/AFNetworkActivityIndicatorManager.h>
#import "EDColor.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
  // Override point for customization after application launch.
  [Fabric with:@[CrashlyticsKit]];

  AFNetworkActivityIndicatorManager.sharedManager.enabled = YES;
  [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];

  [self defaultStyles];
  [self defaultCache];

//  self.window = [[UIWindow alloc] initWithFrame:UIScreen.mainScreen.bounds];
//
//  UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"MainStoryboard" bundle:nil];
//
//  UIViewController *viewController = // determine the initial view controller here and instantiate it with [storyboard instantiateViewControllerWithIdentifier:<storyboard id>];
//
//  self.window.rootViewController = viewController;
//  [self.window makeKeyAndVisible]

  return YES;
}

-(void)defaultCache {
  [[NSURLCache sharedURLCache] setMemoryCapacity:(20*1024*1024)];
  [[NSURLCache sharedURLCache] setDiskCapacity:(200*1024*1024)];
}

-(void)defaultStyles{
  UIColor *barTintColor = [UIColor colorWithHexString:@"120c06"];
  [[UINavigationBar appearance] setBarTintColor:barTintColor];
  [[UIToolbar appearance] setBarTintColor:barTintColor];

  [[UINavigationBar appearance] setTintColor:[UIColor whiteColor]];
  [[UIBarButtonItem appearance] setTintColor:[UIColor whiteColor]];
  [[UINavigationBar appearance] setTitleTextAttributes:@{
                                                         NSForegroundColorAttributeName: [UIColor whiteColor]
                                                        }];
}

- (void)applicationWillResignActive:(UIApplication *)application {
  // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
  // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
  // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
  // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
  // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
  // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
  // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
