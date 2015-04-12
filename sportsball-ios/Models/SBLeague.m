//
//  League.m
//  sportsball-ios
//
//  Created by Mike Silvis on 11/6/14.
//  Copyright (c) 2014 Mike Silvis. All rights reserved.
//

#import "SBLeague.h"
#import "SBGame.h"
#import "XHRealTimeBlur.h"
#import "SBUser.h"
#import <SDWebImage/SDWebImagePrefetcher.h>

@implementation SBLeague

- (id)initWithJson:(id)json {
  self = [super init];

  if (self) {
    self.logo = [NSURL URLWithString:json[@"logo"]];

    self.name = json[@"name"];
    self.englishName = json[@"english_name"];
    self.isMonthlySchedule = [NSNumber numberWithBool:[json[@"monthly_schedule"] boolValue]];

    // Dates
    NSMutableArray *dates = [NSMutableArray array];
    for (NSString  *dateString in json[@"schedule"]) {
      NSDate *date = [self.dateFormatter dateFromString:dateString];
      [dates addObject:date];
    }
    self.schedule = dates;

    // Header Images
    NSMutableDictionary *headerURLS = [NSMutableDictionary dictionary];
    for (NSDictionary *headerURL in json[@"header_images"]) {
      headerURLS[headerURL] = [NSURL URLWithString:json[@"header_images"][headerURL]];
    }
    self.headers = headerURLS;

    self.enabled = [NSNumber numberWithBool:json[@"enabled"]];

  }

  return self;
}

- (NSURL *)header {
  NSString *favoriteTeamName = [[SBUser currentUser] favoriteTeam:self];
  if (favoriteTeamName && self.headers[favoriteTeamName]) {
    return self.headers[favoriteTeamName];
  }
  else {
    return [[self.headers allValues] firstObject];
  }
}

- (BOOL)isEnabled {
  return [self.enabled boolValue];
}

+ (void)getSupportedLeagues:(void (^) (NSArray *leagues))success
                   failure:(void (^) (NSError *error))failure {

  bool alreadyReturned = NO;

  if ([SBUser currentUser].leagues.count > 0) {
    if (success) {
      success([SBUser currentUser].leagues);
    }
    alreadyReturned = YES;
  }

  [self dispatchRequest:@"leagues" parameters:nil success:^(id responseObject) {
    NSMutableArray *leagues = [NSMutableArray array];

    for (id league in responseObject[@"leagues"]) {
      SBLeague *newLeague = [[SBLeague alloc] initWithJson:league];
      [leagues addObject:newLeague];
    }

    // Preload all images
    NSMutableArray *imagesToPreload = [NSMutableArray array];
    for (SBLeague *league in leagues) {
      if ([league isEnabled]) {
        [imagesToPreload addObjectsFromArray:[league.headers allValues]];
      }
    }
    [[SDWebImagePrefetcher sharedImagePrefetcher] prefetchURLs:imagesToPreload];

    [SBUser currentUser].leagues = leagues;

    if (!alreadyReturned && success) {
      success(leagues);
    }
  } failure:^(NSError *error) {
    if (failure) {
      failure(error);
    }
  }];
}

- (void)allScoresForDate:(NSDate *)date
             parameters:(NSDictionary *)parameters
                success:(void (^) (NSArray *games))success
                failure:(void (^) (NSError *error))failure {
  if (!date) {
    date = [NSDate date];
  }

  NSDictionary *params = @{
                           @"date": [self.dateFormatter stringFromDate:date]
                          };

  NSString *path = [NSString stringWithFormat:@"leagues/%@/scores", self.name];

  [self dispatchRequest:path parameters:params success:^(id responseObject) {
    success([self parseJSONScores:responseObject]);
  } failure:^(NSError *error) {
    if (failure) {
      failure(error);
    }
  }];
}

- (NSArray *)parseJSONScores:(id)json {
  NSMutableArray *games = [NSMutableArray array];

  for (id score in json[@"scores"]) {
    SBGame *newGame = [[SBGame alloc] initWithJson:score];
    [games addObject:newGame];
  }

  return [NSArray arrayWithArray:games];
}

- (void)getStanding:(void (^) (SBStanding *standings))success
             failure:(void (^) (NSError *error))failure {

  NSString *path = [NSString stringWithFormat:@"leagues/%@/standings", self.name];

  [self dispatchRequest:path parameters:nil success:^(id responseObject) {
    SBStanding *standing = [[SBStanding alloc] initWithJson:responseObject];
    success(standing);
  } failure:^(NSError *error) {
    if (failure) {
      failure(error);
    }
  }];
}

@end
