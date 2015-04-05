//
//  SBConstants.m
//  sportsball-ios
//
//  Created by Mike Silvis on 4/4/15.
//  Copyright (c) 2015 Mike Silvis. All rights reserved.
//

#import "SBConstants.h"

@implementation SBConstants

NSString *const kPlaceholderImageSize = @"600x300";
NSString *const kPlaceholderImage = @"placeholder";
NSString *const kNotificationHideEvent = @"hideNotificationEvent";

CGFloat kHeaderSize = 100;

+ (SBConstants *)sharedInstance {
  static SBConstants *sharedInstance = nil;
    
  @synchronized(self) {
    if (sharedInstance == nil)
      sharedInstance = [[self alloc] init];
  }

  return sharedInstance;
}

- (NSString *)getSecretValueFrom:(NSString *)key {
  NSString *plistPath = [[NSBundle mainBundle] pathForResource:@"secretKeys" ofType:@"plist"];
  NSDictionary *keys = [NSDictionary dictionaryWithContentsOfFile:plistPath];
    
  return [keys objectForKey:key];
}

@end
