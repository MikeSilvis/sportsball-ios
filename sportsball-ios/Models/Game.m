//
//  Game.m
//  sportsball-ios
//
//  Created by Mike Silvis on 10/31/14.
//  Copyright (c) 2014 Mike Silvis. All rights reserved.
//

#import "Game.h"
#import "User.h"

@interface Game ()

@property (nonatomic, strong) NSDateFormatter *localStartTimeDf;
@property (nonatomic, strong) NSDateFormatter *localStartTimeDfWithDate;

@end

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

-(int)favoriteScore {
  NSDictionary *favoriteTeams = [User currentUser].favoriteTeams[self.league];

  return [favoriteTeams[self.awayTeam.dataName] intValue] + [favoriteTeams[self.homeTeam.dataName] intValue];
}

-(NSDateFormatter *)localStartTimeDf {
  if (!_localStartTimeDf) {
    _localStartTimeDf = [[NSDateFormatter alloc] init];
    [_localStartTimeDf setDateFormat: @"h:mm a"];
    [_localStartTimeDf setTimeZone:[NSTimeZone localTimeZone]];
  }

  return _localStartTimeDf;
}

-(NSDateFormatter *)localStartTimeDfWithDate {
  if (!_localStartTimeDfWithDate) {
    _localStartTimeDfWithDate = [[NSDateFormatter alloc] init];
    _localStartTimeDfWithDate.dateStyle = NSDateFormatterMediumStyle;
    _localStartTimeDfWithDate.timeStyle = NSDateFormatterShortStyle;
    [_localStartTimeDfWithDate setTimeZone:[NSTimeZone localTimeZone]];
  }

  return _localStartTimeDfWithDate;
}

-(NSString *)localStartTime {
  return [self.localStartTimeDf stringFromDate:self.startTime];
}

-(NSString *)localStartTimeWithDate {
  return [self.localStartTimeDfWithDate stringFromDate:self.startTime];
}

-(NSString *)homeScoreString {
  return [NSString stringWithFormat:@"%@", self.homeScore];
}

-(NSString *)awayScoreString {
  return [NSString stringWithFormat:@"%@", self.awayScore];
}

@end
