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
  nfl.numberOfWeeks = (NSInteger) 17;

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
  ncf.numberOfWeeks = (NSInteger) 16;

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
  if ([self.name isEqualToString:@"nfl"]) {
    return [self nflDates];
  }
  else if ([self.name isEqualToString:@"ncf"]) {
    return [self ncfDates];
  }
  else {
    return [self dailyDates:date];
  }
}

- (NSArray *)dailyDates:(NSDate *)date {
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

- (BOOL)isWeeky {
  return [self.datePickerType isEqualToString:weeklyDatePicker];
}

-(NSArray *)ncfDates {
  return @[
            [NSDate dateWithYear:2014 month:8 day:28],
            [NSDate dateWithYear:2014 month:9 day:6],
            [NSDate dateWithYear:2014 month:9 day:13],
            [NSDate dateWithYear:2014 month:9 day:20],
            [NSDate dateWithYear:2014 month:9 day:27],
            [NSDate dateWithYear:2014 month:10 day:4],
            [NSDate dateWithYear:2014 month:10 day:11],
            [NSDate dateWithYear:2014 month:10 day:11],
            [NSDate dateWithYear:2014 month:10 day:18],
            [NSDate dateWithYear:2014 month:10 day:25],
            [NSDate dateWithYear:2014 month:11 day:1],
            [NSDate dateWithYear:2014 month:11 day:8],
            [NSDate dateWithYear:2014 month:11 day:15],
            [NSDate dateWithYear:2014 month:11 day:22],
            [NSDate dateWithYear:2014 month:11 day:29],
            [NSDate dateWithYear:2014 month:12 day:6],
            [NSDate dateWithYear:2014 month:12 day:13],
          ];
}

-(NSArray *)nflDates {
  return @[
           // Week 1
           [NSDate dateWithYear:2014 month:9 day:4],
           [NSDate dateWithYear:2014 month:9 day:7],
           [NSDate dateWithYear:2014 month:9 day:8],

           // Week 2
           [NSDate dateWithYear:2014 month:9 day:11],
           [NSDate dateWithYear:2014 month:9 day:14],
           [NSDate dateWithYear:2014 month:9 day:15],

           // Week 3
           [NSDate dateWithYear:2014 month:9 day:18],
           [NSDate dateWithYear:2014 month:9 day:21],
           [NSDate dateWithYear:2014 month:9 day:22],

           // Week 4
           [NSDate dateWithYear:2014 month:9 day:25],
           [NSDate dateWithYear:2014 month:9 day:28],
           [NSDate dateWithYear:2014 month:9 day:29],

           // Week 5
           [NSDate dateWithYear:2014 month:10 day:2],
           [NSDate dateWithYear:2014 month:10 day:5],
           [NSDate dateWithYear:2014 month:10 day:6],

           // Week 6
           [NSDate dateWithYear:2014 month:10 day:9],
           [NSDate dateWithYear:2014 month:10 day:12],
           [NSDate dateWithYear:2014 month:10 day:13],

           // Week 7
           [NSDate dateWithYear:2014 month:10 day:16],
           [NSDate dateWithYear:2014 month:10 day:19],
           [NSDate dateWithYear:2014 month:10 day:20],

           // Week 8
           [NSDate dateWithYear:2014 month:10 day:23],
           [NSDate dateWithYear:2014 month:10 day:26],
           [NSDate dateWithYear:2014 month:10 day:27],

           // Week 9
           [NSDate dateWithYear:2014 month:10 day:30],
           [NSDate dateWithYear:2014 month:11 day:2],
           [NSDate dateWithYear:2014 month:11 day:3],

           // Week 10
           [NSDate dateWithYear:2014 month:11 day:6],
           [NSDate dateWithYear:2014 month:11 day:9],
           [NSDate dateWithYear:2014 month:11 day:10],

           // Week 11
           [NSDate dateWithYear:2014 month:11 day:13],
           [NSDate dateWithYear:2014 month:11 day:16],
           [NSDate dateWithYear:2014 month:11 day:17],

           // Week 12
           [NSDate dateWithYear:2014 month:11 day:20],
           [NSDate dateWithYear:2014 month:11 day:23],
           [NSDate dateWithYear:2014 month:11 day:24],

           // Week 13
           [NSDate dateWithYear:2014 month:11 day:27],
           [NSDate dateWithYear:2014 month:11 day:30],
           [NSDate dateWithYear:2014 month:12 day:1],

           // Week 14
           [NSDate dateWithYear:2014 month:12 day:4],
           [NSDate dateWithYear:2014 month:12 day:7],
           [NSDate dateWithYear:2014 month:12 day:8],

           // Week 15
           [NSDate dateWithYear:2014 month:12 day:11],
           [NSDate dateWithYear:2014 month:12 day:14],
           [NSDate dateWithYear:2014 month:12 day:15],

           // Week 16
           [NSDate dateWithYear:2014 month:12 day:18],
           [NSDate dateWithYear:2014 month:12 day:20],
           [NSDate dateWithYear:2014 month:12 day:21],
           [NSDate dateWithYear:2014 month:12 day:22],

           // Week 17
           [NSDate dateWithYear:2014 month:12 day:28],
          ];
}

@end
