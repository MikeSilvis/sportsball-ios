//
//  User.m
//  sportsball-ios
//
//  Created by Mike Silvis on 11/23/14.
//  Copyright (c) 2014 Mike Silvis. All rights reserved.
//

#import "User.h"

static NSString *lastOpenedLeagueKey = @"lastOpenedLeague";

@implementation User

+ (User *)currentUser {
  static User *currentUser = nil;
  @synchronized(self) {
    if (currentUser == nil)
      currentUser = [[self alloc] init];
  }
  return currentUser;
}

-(id)init {
  self = [super init];
  if (self) {
    [self setUserDefaults];
  }
  return self;
}

-(void)setLastOpenedLeague:(NSNumber *)lastOpenedLeague {
  _lastOpenedLeague = lastOpenedLeague;

  [self syncUserDefaults];
}

- (void)syncUserDefaults {
  NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
  [defaults setObject:self.lastOpenedLeague forKey:lastOpenedLeagueKey];
  [defaults synchronize];
}

-(void)setUserDefaults {
  NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
  self.lastOpenedLeague = [defaults objectForKey:lastOpenedLeagueKey];
}

@end