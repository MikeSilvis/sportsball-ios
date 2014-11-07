//
//  League.m
//  sportsball-ios
//
//  Created by Mike Silvis on 11/6/14.
//  Copyright (c) 2014 Mike Silvis. All rights reserved.
//

#import "League.h"
#import "Game.h"

@implementation League

+(NSArray *)supportedLeagues {
  League *nfl = [[League alloc] init];
  nfl.logo = @"nfl-logo";
  nfl.background = @"nfl-header-1";
  nfl.name = @"nfl";

  League *nhl = [[League alloc] init];
  nhl.logo = @"nhl-logo";
  nhl.name = @"nhl";
  nhl.background = @"nhl-header-1";

  return @[
           nhl,
           nfl
           ];

}

-(NSString *)scoresUrl {
  return [NSString stringWithFormat:@"http://sportsball.herokuapp.com/api/scores/%@", self.name];
}

-(NSDateFormatter *)dateFormatter {
  if (!_dateFormatter) {
    _dateFormatter = [[NSDateFormatter alloc] init];
    [_dateFormatter setDateFormat:@"yyyy-MM-dd"];
  }

  return _dateFormatter;
}

-(void)allScoresForDate:(NSDate *)date
             parameters:(NSDictionary *)parameters
                success:(void (^) (NSArray *games))success
                failure:(void (^) (NSError *error))failure {
  if (!date) {
    date = [NSDate date];
  }

  NSDictionary *params = @{
                           @"date": [self.dateFormatter stringFromDate:[NSDate date]]
                          };

  NSString *path = [NSString stringWithFormat:@"scores/%@", self.name];

  [self dispatchRequest:path parameters:params success:^(id responseObject) {

    NSMutableArray *games = [NSMutableArray array];

    for (id score in responseObject[@"scores"]) {
        Game *newGame = [[Game alloc] initWithJson:score];
        [games addObject:newGame];
    }

    success(games);
  } failure:^(NSError *error) {
    failure(error);
  }];
}

@end
