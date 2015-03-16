//
//  Team.m
//  sportsball-ios
//
//  Created by Mike Silvis on 10/31/14.
//  Copyright (c) 2014 Mike Silvis. All rights reserved.
//

#import "SBTeam.h"
#import "SBUser.h"

@implementation SBTeam

static int const kFavoriteCount = 6;

- (id)initWithJson:(id)json {
  self = [super init];

  if (self) {
    self.name       = json[@"name"];
    self.logoUrl    = [NSURL URLWithString:json[@"logo"]];
    self.record     = json[@"record"];
    self.dataName   = json[@"data_name"];
    self.leagueName = json[@"league"];
    self.abbr       = json[@"abbr"];
  }

  return self;
}

- (NSString *)dataName {
  return [_dataName lowercaseString];
}

- (NSString *)formattedRecord {
  return [NSString stringWithFormat:@"(%@)", self.record];
}

+ (void)incrementFavoriteTeam:(SBTeam *)team withSuccess:(void (^) (PFObject *object))success {
  NSString *parseClassName = @"TeamCount";
  NSString *favoriteCount = @"favoriteCount";

  PFQuery *query = [PFQuery queryWithClassName:parseClassName];
  [query whereKey:@"user" equalTo:[SBUser currentUser].currentPfUser];
  [query whereKey:@"league" equalTo:team.leagueName];
  [query whereKey:@"team" equalTo:team.name];
  [query whereKey:@"teamDataName" equalTo:team.dataName];

  [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
    if ([objects count] > 0) {
      PFObject *teamRecord = [objects firstObject];
      [teamRecord incrementKey:favoriteCount];
      [teamRecord saveInBackground];
      success(teamRecord);
    }
    else {
      PFObject *teamRecord = [PFObject objectWithClassName:parseClassName];
      teamRecord[@"user"] = [SBUser currentUser].currentPfUser;
      teamRecord[@"league"] = team.leagueName;
      teamRecord[@"team"] = team.name;
      teamRecord[@"teamDataName"] = team.dataName;
      teamRecord[favoriteCount] = @1;
      [teamRecord saveInBackground];
      success(teamRecord);
    }
  }];

}

- (PFObject *)parseObject {
  for (PFObject *object in [SBUser currentUser].favoriteTeams) {
    if ([object[@"teamDataName"] isEqualToString:self.dataName]) {
      return object;
    }
  }

  return nil;
}

- (int)favoriteScore {
  if ([self parseObject]) {
    return [[self parseObject][@"favoriteCount"] intValue];
  }

  return 0;
}

- (BOOL)isFavorableTeam {
  return ([self favoriteScore] > kFavoriteCount) && (([self parseObject][@"pushEnabled"] == nil) || [self parseObject][@"pushEnabled"]);
}

@end
