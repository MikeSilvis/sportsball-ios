//
//  Game.m
//  sportsball-ios
//
//  Created by Mike Silvis on 10/31/14.
//  Copyright (c) 2014 Mike Silvis. All rights reserved.
//

#import "Game.h"

@implementation Game

-(Team *)winningTeam {
  if ([self.awayScore doubleValue] > [self.homeScore doubleValue]) {
    return self.awayTeam;
  } else {
    return self.homeTeam;
  }
}

-(Team *)teamFromDataName:(NSString *)dataName {
  dataName = [dataName lowercaseString];

  if ([self.awayTeam.dataName isEqualToString:dataName]) {
    return self.awayTeam;
  }
  else if ([self.homeTeam.dataName isEqualToString:dataName]) {
    return self.homeTeam;
  }

  return nil;
}

-(id)initWithJson:(id)json {
  self = [super init];

  if (self) {
    self.homeTeam = [[Team alloc] initWithJson:json[@"home_team"]];
    self.homeScore = json[@"home_score"];

    self.awayTeam = [[Team alloc] initWithJson:json[@"away_team"]];
    self.awayScore = json[@"away_score"];
    self.league = json[@"league"];

    self.timeRemaining = json[@"time_remaining"];
    self.currentPeriod = json[@"progress"];
    self.endedIn = json[@"ended_in"];

    self.startTime = [NSDate dateWithTimeIntervalSince1970:[json[@"start_time"] doubleValue]];
    self.moneyLine = json[@"line"];
    self.state = json[@"state"];

    self.boxscoreId = json[@"boxscore"];
    self.previewId = json[@"preview"];
  }

  return self;
}

-(void)findBoxscore:(NSDictionary *)paramaters
            success:(void (^) (Boxscore *))success
            failure:(void (^) (NSError *error))failure {

    NSString *path = [NSString stringWithFormat:@"leagues/%@/boxscores/%@", self.league, self.boxscoreId];

    [self dispatchRequest:path parameters:paramaters success:^(id responseObject) {
      Boxscore *boxscore = [[Boxscore alloc] initWithJson:responseObject[@"boxscore"]];
      success(boxscore);
    } failure:^(NSError *error) {
      if (failure) {
        failure(error);
      }
    }];
}

-(void)findPreview:(NSDictionary *)paramaters
            success:(void (^) (Preview *))success
            failure:(void (^) (NSError *error))failure {

    NSString *path = [NSString stringWithFormat:@"leagues/%@/previews/%@", self.league, self.previewId];

    [self dispatchRequest:path parameters:paramaters success:^(id responseObject) {
      Preview *preview = [[Preview alloc] initWithJson:responseObject[@"preview"]];
      success(preview);
    } failure:^(NSError *error) {
      if (failure) {
        failure(error);
      }
    }];
}

- (BOOL)isOver {
  return [self.state isEqualToString:@"postgame"];
}

-(BOOL)isInProgress {
  return [self.state isEqualToString:@"in-progress"];
}

-(BOOL)isPregame {
  return [self.state isEqualToString:@"pregame"];
}

-(NSDateFormatter *)df {
  if (!_df) {
    _df = [[NSDateFormatter alloc] init];
    [_df setDateFormat: @"h:mm a"];
    [_df setTimeZone:[NSTimeZone localTimeZone]];
  }

  return _df;
}

-(NSString *)localStartTime {
  return [self.df stringFromDate:self.startTime];
}

-(NSString *)homeScoreString {
  return [NSString stringWithFormat:@"%@", self.homeScore];
}

-(NSString *)awayScoreString {
  return [NSString stringWithFormat:@"%@", self.awayScore];
}

@end
