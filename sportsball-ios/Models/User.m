//
//  User.m
//  sportsball-ios
//
//  Created by Mike Silvis on 11/23/14.
//  Copyright (c) 2014 Mike Silvis. All rights reserved.
//

#import "User.h"
#import "League.h"

static NSString *lastOpenedLeagueKey = @"lastOpenedLeague";
static NSString *allLeagues = @"allLeagues";

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

-(void)setLeagues:(NSArray *)leagues {
  _leagues = leagues;

  [self syncUserDefaults];
}

- (void)syncUserDefaults {
  NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
  [defaults setObject:self.lastOpenedLeague forKey:lastOpenedLeagueKey];

  NSMutableArray *encodedLeagues = [NSMutableArray array];
  for (League *league in self.leagues) {
    NSData *encodedNewLeague = [NSKeyedArchiver archivedDataWithRootObject:league];
    [encodedLeagues addObject:encodedNewLeague];
  }

  if (encodedLeagues.count > 0) {
    [defaults setObject:encodedLeagues forKey:allLeagues];
  }

  [defaults synchronize];
}

-(void)setUserDefaults {
  NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
  self.lastOpenedLeague = [defaults objectForKey:lastOpenedLeagueKey];

  NSArray *encodedLeagues = [defaults objectForKey:allLeagues];
  NSMutableArray *leagues = [NSMutableArray array];
  for (NSData *encodedLeague in encodedLeagues) {
      League *league = (League *)[NSKeyedUnarchiver unarchiveObjectWithData:encodedLeague];
      [leagues addObject:league];
  }

  self.leagues = leagues;
}

@end