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


@implementation League

static NSTimeInterval kSecondsInDay = 86400;
static NSString *weeklyDatePicker = @"weekly";
static NSString *dailyDatePicker = @"daily";

+(NSArray *)supportedLeagues {
  League *nfl = [[League alloc] init];
  nfl.logo = @"nfl-logo";
  nfl.header = @"nfl-header";
  nfl.name = @"nfl";
  nfl.background = @"nfl-background";
  nfl.datePickerType = weeklyDatePicker;
  nfl.numberOfWeeks = @(17);

  League *nhl = [[League alloc] init];
  nhl.logo = @"nhl-logo";
  nhl.header = @"nhl-header";
  nhl.name = @"nhl";
  nhl.background = @"nhl-background";
  nhl.datePickerType = dailyDatePicker;

  League *ncf = [[League alloc] init];
  ncf.logo = @"ncf-logo";
  ncf.header = @"ncf-header";
  ncf.name = @"ncf";
  ncf.datePickerType = weeklyDatePicker;
  ncf.numberOfWeeks = @(16);

  return @[
           nhl,
           nfl,
           ncf
           ];

}

-(UIImage *)blurredHeader{
  if (!_blurredHeader) {
    float blurred = 2.5f;

    _blurredHeader = [[UIImage imageNamed:self.header] blurredImage:blurred];
  }

  return _blurredHeader;
}

-(void)setHeader:(NSString *)header {
  _header = header;
  self.blurredHeader = nil;
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

-(NSArray *)weeksForDatePicker:(NSDate *)date {

  return @[];
}

- (NSArray *)datesForPicker:(NSDate *)date {
  NSMutableArray *dates = [NSMutableArray array];
  int days = 10;

  for (NSInteger day = 0; day < days; day++) {
    [dates addObject:[date dateByAddingTimeInterval:-(day * kSecondsInDay)]];
  }

  for (NSInteger day = 1; day < days; day++) {
    [dates addObject:[date dateByAddingTimeInterval:(day * kSecondsInDay)]];
  }

  return [NSMutableArray arrayWithArray:dates];
}

-(BOOL)isWeekly{
  return [self.datePickerType isEqualToString:weeklyDatePicker];
}

@end
