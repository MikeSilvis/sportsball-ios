//
//  Game.m
//  sportsball-ios
//
//  Created by Mike Silvis on 10/31/14.
//  Copyright (c) 2014 Mike Silvis. All rights reserved.
//

#import "SBGame.h"
#import "SBUser.h"
#import "SBSchedule.h"

@interface SBGame ()

@property (nonatomic, strong) NSDateFormatter *localStartTimeDfWithDate;

@end

@implementation SBGame

- (SBTeam *)winningTeam {
  if ([self.awayScore doubleValue] > [self.homeScore doubleValue]) {
    return self.awayTeam;
  } else {
    return self.homeTeam;
  }
}

- (SBTeam *)teamFromDataName:(NSString *)dataName {
  dataName = [dataName lowercaseString];

  if ([self.awayTeam.dataName isEqualToString:dataName]) {
    return self.awayTeam;
  }
  else if ([self.homeTeam.dataName isEqualToString:dataName]) {
    return self.homeTeam;
  }

  return nil;
}

- (id)initWithJson:(id)json {
  self = [super init];

  if (self) {
    self.homeTeam = [[SBTeam alloc] initWithJson:json[@"home_team"]];
    self.homeTeam.isAway = NO;
    self.homeScore = json[@"home_score"];

    self.awayTeam = [[SBTeam alloc] initWithJson:json[@"away_team"]];
    self.awayTeam.isAway = YES;
    self.awayScore = json[@"away_score"];
    self.leagueName = json[@"league"];

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

- (void)findBoxscore:(NSDictionary *)paramaters
            success:(void (^) (SBBoxscore *))success
            failure:(void (^) (NSError *error))failure {

    NSString *path = [NSString stringWithFormat:@"leagues/%@/boxscores/%@", self.leagueName, self.boxscoreId];

    [self dispatchRequest:path parameters:paramaters success:^(id responseObject) {
      SBBoxscore *boxscore = [[SBBoxscore alloc] initWithJson:responseObject[@"boxscore"]];
      success(boxscore);
    } failure:^(NSError *error) {
      if (failure) {
        failure(error);
      }
    }];
}

- (void)findPreview:(NSDictionary *)paramaters
            success:(void (^) (SBPreview *))success
            failure:(void (^) (NSError *error))failure {

    NSString *path = [NSString stringWithFormat:@"leagues/%@/previews/%@", self.leagueName, self.previewId];

    [self dispatchRequest:path parameters:paramaters success:^(id responseObject) {
      SBPreview *preview = [[SBPreview alloc] initWithJson:responseObject[@"preview"]];
      success(preview);
    } failure:^(NSError *error) {
      if (failure) {
        failure(error);
      }
    }];
}

- (void)findSchedules:(NSDictionary *)paramaters
              success:(void (^) (NSArray *))success
              failure:(void (^) (NSError *error))failure {

    NSString *path = [NSString stringWithFormat:@"leagues/%@/schedules", self.leagueName];

    [self dispatchRequest:path parameters:paramaters success:^(id responseObject) {
      NSMutableArray *schedules = [NSMutableArray array];

      // All Teams Schedules
      for (id teamScheduleJson in responseObject[@"schedules"]) {
        NSMutableArray *teamSchedules = [NSMutableArray array];
        for (id scheduleJson in teamScheduleJson[@"games"]) {
          SBSchedule *schedule = [[SBSchedule alloc] initWithJson:scheduleJson];
          [teamSchedules addObject:schedule];
        }

        [schedules addObject:teamSchedules];
      }

      success(schedules);
    } failure:^(NSError *error) {
      if (failure) {
        failure(error);
      }
    }];
}

- (BOOL)isOver {
  return [self.state isEqualToString:@"postgame"];
}

- (BOOL)isInProgress {
  return [self.state isEqualToString:@"in-progress"];
}

- (BOOL)isPregame {
  return [self.state isEqualToString:@"pregame"];
}

- (int)favoriteScore {
  return [self.awayTeam favoriteScore] + [self.homeTeam favoriteScore];
}

- (NSDateFormatter *)localStartTimeDfWithDate {
  if (!_localStartTimeDfWithDate) {
    _localStartTimeDfWithDate = [[NSDateFormatter alloc] init];
    _localStartTimeDfWithDate.dateStyle = NSDateFormatterMediumStyle;
    _localStartTimeDfWithDate.timeStyle = NSDateFormatterShortStyle;
    [_localStartTimeDfWithDate setTimeZone:[NSTimeZone localTimeZone]];
  }

  return _localStartTimeDfWithDate;
}

- (NSString *)localStartTime {
  return [self.localStartTimeDf stringFromDate:self.startTime];
}

- (NSString *)localStartTimeWithDate {
  return [self.localStartTimeDfWithDate stringFromDate:self.startTime];
}

- (NSString *)homeScoreString {
  return [NSString stringWithFormat:@"%@", self.homeScore];
}

- (NSString *)awayScoreString {
  return [NSString stringWithFormat:@"%@", self.awayScore];
}

- (NSString *)description {
  return [NSString stringWithFormat:@"<SBGame> %@ %@", self.awayTeam.name, self.homeTeam.name];
}

- (BOOL)hasPreviewOrRecap {
  if (self.isPregame && self.preview && self.preview.headline) {
    return YES;
  }
  else if (self.isOver && self.boxscore && self.boxscore.recap && self.boxscore.recap.headline) {
    return YES;
  }

  return NO;
}

- (BOOL)hasPreviewOrRecapPhoto {
  if (self.isOver && self.boxscore && self.boxscore.recap && self.boxscore.recap.photoURL) {
    return YES;
  }

  return NO;
}

@end
