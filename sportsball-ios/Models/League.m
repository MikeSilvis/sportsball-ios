//
//  League.m
//  sportsball-ios
//
//  Created by Mike Silvis on 11/6/14.
//  Copyright (c) 2014 Mike Silvis. All rights reserved.
//

#import "League.h"
#import "Game.h"
#import "UIImage+Blur.h"
#import "XHRealTimeBlur.h"
#import "NSDate+SBDateWithYear.h"
#import "User.h"

@implementation League

static NSString *leaguesKey = @"allLeagues";

-(id)initWithJson:(id)json {
  self = [super init];

  if (self) {
    self.logo = [NSURL URLWithString:json[@"logo"]];
    self.name = json[@"name"];
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

    NSString *favoriteTeamName = [[User currentUser] favoriteTeam:self];
    if (favoriteTeamName && self.blurredHeaders[favoriteTeamName]) {
      self.header = self.headers[favoriteTeamName];
      self.blurredHeader = self.blurredHeaders[favoriteTeamName];
    }
    else {
      self.header = [NSURL URLWithString:json[@"header_image"]];
      self.blurredHeader = [NSURL URLWithString:json[@"header_blurred_image"]];
    }
  }

  return self;
}

+(void)getSupportedLeagues:(void (^) (NSArray *leagues))success
                   failure:(void (^) (NSError *error))failure {

  bool alreadyReturned = NO;

  if ([User currentUser].leagues.count > 0) {
    success([User currentUser].leagues);
    alreadyReturned = YES;
  }

  [self dispatchRequest:@"leagues" parameters:nil success:^(id responseObject) {
    NSMutableArray *leagues = [NSMutableArray array];

    for (id league in responseObject[@"leagues"]) {
      League *newLeague = [[League alloc] initWithJson:league];
      [leagues addObject:newLeague];
    }

    [User currentUser].leagues = leagues;

    if (!alreadyReturned) {
      success(leagues);
    }
  } failure:^(NSError *error) {
    if (failure) {
      failure(error);
    }
  }];
}

-(void)allScoresForDate:(NSDate *)date
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
        Game *newGame = [[Game alloc] initWithJson:score];
        [games addObject:newGame];
    }

    success([NSArray arrayWithArray:games]);
  } failure:^(NSError *error) {
    if (failure) {
      failure(error);
    }
  }];
}

@end
