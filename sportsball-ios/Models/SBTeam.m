//
//  Team.m
//  sportsball-ios
//
//  Created by Mike Silvis on 10/31/14.
//  Copyright (c) 2014 Mike Silvis. All rights reserved.
//

#import "SBTeam.h"
#import "SBUser.h"
#import <Parse/Parse.h>

@implementation SBTeam

- (id)initWithJson:(id)json {
  self = [super init];

  if (self) {
    self.name = json[@"name"];
    self.logoUrl = [NSURL URLWithString:json[@"logo"]];
    self.record = json[@"record"];
    self.dataName = json[@"data_name"];
    self.leagueName = json[@"league"];
  }

  return self;
}

- (NSString *)dataName {
  return [_dataName lowercaseString];
}

- (NSString *)formattedRecord {
  return [NSString stringWithFormat:@"(%@)", self.record];
}

+ (void)incrementFavoriteTeam:(SBTeam *)team {
  NSString *parseClassName = @"TeamCount";
  NSString *favoriteCount = @"favoriteCount";

  PFQuery *query = [PFQuery queryWithClassName:parseClassName];
  [query whereKey:@"user" equalTo:[PFUser currentUser]];
  [query whereKey:@"league" equalTo:team.leagueName];
  [query whereKey:@"team" equalTo:team.name];

  [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
    if ([objects count] > 0) {
      PFObject *teamRecord = [objects firstObject];
      [teamRecord incrementKey:favoriteCount];
      [teamRecord saveInBackground];
    }
    else {
      PFObject *teamRecord = [PFObject objectWithClassName:parseClassName];
      teamRecord[@"user"] = [PFUser currentUser];
      teamRecord[@"league"] = team.leagueName;
      teamRecord[@"team"] = team.name;
      teamRecord[favoriteCount] = @1;
      [teamRecord saveInBackground];
    }
  }];

}

- (int)favoriteScore {
  NSDictionary *favoriteTeams = [SBUser currentUser].favoriteTeams[self.leagueName];

  return [favoriteTeams[self.dataName] intValue];
}

@end
