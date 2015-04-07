//
//  AppDelegate.m
//  sportsball-ios
//
//  Created by Mike Silvis on 10/31/14.
//  Copyright (c) 2014 Mike Silvis. All rights reserved.
//

#import "AppDelegate.h"
#import "SBUser.h"

#import "EDColor.h"
#import <Fabric/Fabric.h>
#import <Crashlytics/Crashlytics.h>
#import <AFNetworking/AFNetworkActivityIndicatorManager.h>
#import <Parse/Parse.h>
#import <MPGNotification.h>
#import "UIImage+FontAwesome.h"
#import <AVKit/AVKit.h>
#import "Mixpanel.h"
#import "SBConstants.h"

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
  [Fabric with:@[CrashlyticsKit]];

  AFNetworkActivityIndicatorManager.sharedManager.enabled = YES;
  [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];

  [self defaultStyles];
  [self defaultCache];
  [self configureParse:launchOptions];
  [self configureMixPanel];
  [self setInitialWindow];
  
  [[SBUser currentUser] incrementAppOpens];

  return YES;
}

- (void)setInitialWindow {
  self.window = [[UIWindow alloc] initWithFrame:UIScreen.mainScreen.bounds];

  NSString *initialViewId;
  if ([[SBUser currentUser].leagues count] > 0) {
    initialViewId = @"leagueIndexViewController";
    [SBLeague getSupportedLeagues:nil failure:nil];
  }
  else {
    initialViewId = @"leagueLoadingViewController";
  }

  UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
  UIViewController *viewController = [storyboard instantiateViewControllerWithIdentifier:initialViewId];

  self.window.rootViewController = viewController;
  [self.window makeKeyAndVisible];
}

- (void)configureMixPanel {
  NSString *mixpanelToken = [[SBConstants sharedInstance] getSecretValueFrom:@"MIXPANEL_TOKEN"];
  [Mixpanel sharedInstanceWithToken:mixpanelToken];
}

- (void)configureParse:(NSDictionary *)launchOptions {
  NSString *parseApiKey = [[SBConstants sharedInstance] getSecretValueFrom:@"PARSE_API_KEY"];
  NSString *parseClientKey = [[SBConstants sharedInstance] getSecretValueFrom:@"PARSE_CLIENT_KEY"];
  [Parse setApplicationId:parseApiKey clientKey:parseClientKey];
 
  [PFAnalytics trackAppOpenedWithLaunchOptions:launchOptions];
}

- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
  NSString *userChannel = [NSString stringWithFormat: @"user_%@", [SBUser currentUser].currentPfUser.objectId];

  PFInstallation *currentInstallation = [PFInstallation currentInstallation];
  [currentInstallation setDeviceTokenFromData:deviceToken];
  currentInstallation.channels = @[ userChannel ];
  [currentInstallation saveInBackground];
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo {

  CGFloat iconSize = 32;
  FAKFontAwesome *warningIcon = [FAKFontAwesome thumbsUpIconWithSize:iconSize];
  UIImage *notificationIcon =  [UIImage imageWithFontAwesomeIcon:warningIcon andSize:iconSize andColor:@"#fff"];

  MPGNotification *notification = [MPGNotification notificationWithHostViewController:self.window.rootViewController
                                                                                title:@"New Notification"
                                                                             subtitle:userInfo[@"aps"][@"alert"]
                                                                      backgroundColor:[UIColor colorWithHexString:@"274385"]
                                                                            iconImage:notificationIcon];
  notification.animationType = MPGNotificationAnimationTypeDrop;
  [notification show];
}

- (void)defaultCache {
  [[NSURLCache sharedURLCache] setMemoryCapacity:(20*1024*1024)];
  [[NSURLCache sharedURLCache] setDiskCapacity:(400*1024*1024)];
}

- (void)defaultStyles{
  // UINavigationBar
  UIColor *barTintColor = [UIColor colorWithHexString:@"120c06"];
  [[UINavigationBar appearance] setBarTintColor:barTintColor];
  [[UIToolbar appearance] setBarTintColor:barTintColor];

  [[UINavigationBar appearance] setTintColor:[UIColor whiteColor]];
  [[UIBarButtonItem appearance] setTintColor:[UIColor whiteColor]];
  [[UINavigationBar appearance] setTitleTextAttributes:@{
                                                         NSForegroundColorAttributeName: [UIColor whiteColor]
                                                        }];


  UIColor *selectedColor = [UIColor whiteColor];
  [[UITabBar appearance] setTintColor:selectedColor];
  [[UITabBarItem appearance] setTitleTextAttributes:@{
                     NSForegroundColorAttributeName: selectedColor,
                                NSFontAttributeName: [UIFont fontWithName:@"Avenir" size:10.0f]
                                                     }
                                           forState:UIControlStateSelected];
}

- (NSUInteger) application:(UIApplication *)application supportedInterfaceOrientationsForWindow:(UIWindow *)window {
  if ([NSStringFromClass([[window.rootViewController presentedViewController] class]) isEqualToString:@"AVFullScreenViewController"]) {
    return UIInterfaceOrientationMaskAllButUpsideDown;
  }

  return UIInterfaceOrientationMaskPortrait;
}

- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url {
  if ([url.host isEqualToString:@"scores"]) {

    for (int i = 0; i < [[SBUser currentUser].leagues count]; i++) {
      SBLeague *league = [SBUser currentUser].leagues[i];

      if ([league.name isEqualToString:[url lastPathComponent]]) {
        [SBUser currentUser].lastOpenedLeagueIndex = @(i);
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        UIViewController *viewController = [storyboard instantiateViewControllerWithIdentifier:@"leagueIndexViewController"];

        self.window.rootViewController = viewController;
        [self.window makeKeyAndVisible];
      }
    }
  }

  return YES;
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
