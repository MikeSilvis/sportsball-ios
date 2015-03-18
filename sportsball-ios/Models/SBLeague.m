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

@implementation SBLeague

- (id)initWithJson:(id)json {
  self = [super init];

  if (self) {
    self.logo = [NSURL URLWithString:json[@"logo"]];
    self.secondaryLogo = [NSURL URLWithString:json[@"secondary_logo"]];

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

    // Blurred Header Images
    NSMutableDictionary *blurredHeaderURLS = [NSMutableDictionary dictionary];
    for (NSDictionary *headerURL in json[@"header_blurred_images"]) {
      blurredHeaderURLS[headerURL] = [NSURL URLWithString:json[@"header_blurred_images"][headerURL]];
    }
    self.blurredHeaders = blurredHeaderURLS;

    NSString *favoriteTeamName = [[SBUser currentUser] favoriteTeam:self];
    if (favoriteTeamName && self.blurredHeaders[favoriteTeamName]) {
      self.header = self.headers[favoriteTeamName];
      self.blurredHeader = self.blurredHeaders[favoriteTeamName];
    }
    else {
      self.header = [[self.headers allValues] firstObject];
      self.blurredHeader = [[self.blurredHeaders allValues] firstObject];
    }
  }

  return self;
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

    NSMutableArray *games = [NSMutableArray array];

    for (id score in responseObject[@"scores"]) {
      SBGame *newGame = [[SBGame alloc] initWithJson:score];
      [games addObject:newGame];
    }

    success([NSArray arrayWithArray:games]);
  } failure:^(NSError *error) {
    if (failure) {
      failure(error);
    }
  }];
}

- (void)getStandings:(void (^) (NSDictionary *standings))success
             failure:(void (^) (NSError *error))failure {

  NSString *path = [NSString stringWithFormat:@"leagues/%@/standings", self.name];

  [self dispatchRequest:path parameters:nil success:^(id responseObject) {
    NSMutableDictionary *divisions = [NSMutableDictionary dictionary];

    for (id division in responseObject[@"standings"][@"divisions"]) {
      NSMutableArray *teams = [NSMutableArray array];

      for (id team in responseObject[@"standings"][@"divisions"][division]) {
        SBTeam *newTeam = [[SBTeam alloc] initWithJson:team];
        [teams addObject:newTeam];
      }
      divisions[division] = [NSArray arrayWithArray:teams];
    }

    success([NSMutableDictionary dictionaryWithDictionary:divisions]);
  } failure:^(NSError *error) {
    if (failure) {
      failure(error);
    }
  }];
}

@end
