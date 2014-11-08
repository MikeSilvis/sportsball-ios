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

@implementation League

+(NSArray *)supportedLeagues {
  League *nfl = [[League alloc] init];
  nfl.logo = @"nfl-logo";
  nfl.header = @"nfl-header-1";
  nfl.name = @"nfl";
  nfl.background = @"nfl-background";

  League *nhl = [[League alloc] init];
  nhl.logo = @"nhl-logo";
  nhl.header = @"nhl-header-1";
  nhl.name = @"nhl";
  nhl.background = @"nhl-background";

  return @[
           nhl,
           nfl
           ];

}

-(UIImage *)blurredHeader{
  if (!_blurredHeader) {
    float quality = .00001f;
    float blurred = 2.5f;

    NSData *imageData = UIImageJPEGRepresentation([UIImage imageNamed:self.header], quality);
    _blurredHeader = [[UIImage imageWithData:imageData] blurredImage:blurred];
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
                           @"date": [self.dateFormatter stringFromDate:[NSDate date]]
                          };

  NSString *path = [NSString stringWithFormat:@"scores/%@", self.name];

  [self dispatchRequest:path parameters:params success:^(id responseObject) {

    NSMutableArray *games = [NSMutableArray array];

    for (id score in responseObject[@"scores"]) {
        Game *newGame = [[Game alloc] initWithJson:score];
        [games addObject:newGame];
    }

    success([NSArray arrayWithArray:games]);
  } failure:^(NSError *error) {
    failure(error);
  }];
}

@end
