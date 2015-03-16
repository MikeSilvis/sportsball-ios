//
//  Team.h
//  sportsball-ios
//
//  Created by Mike Silvis on 10/31/14.
//  Copyright (c) 2014 Mike Silvis. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SBModel.h"
#import <Parse/Parse.h>

@interface SBTeam : SBModel

@property (nonatomic, strong) NSURL *logoUrl;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *record;
@property (nonatomic, strong) NSString *dataName;
@property (nonatomic, strong) NSString *leagueName;
@property (nonatomic, strong) NSString *abbr;
@property BOOL isAway;

- (NSString *)formattedRecord;
- (int)favoriteScore;
+ (void)incrementFavoriteTeam:(SBTeam *)team withSuccess:(void (^) (PFObject *object))success;
- (PFObject *)parseObject;
- (BOOL)isFavorableTeam;

@end
