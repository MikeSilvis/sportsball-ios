//
//  Game.h
//  sportsball-ios
//
//  Created by Mike Silvis on 10/31/14.
//  Copyright (c) 2014 Mike Silvis. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SBModel.h"
#import "SBTeam.h"
#import "SBBoxscore.h"
#import "SBPreview.h"

@interface SBGame : SBModel

@property (nonatomic, strong) SBTeam *awayTeam;
@property (nonatomic, strong) SBTeam *homeTeam;
@property (nonatomic, strong) SBBoxscore *boxscore;
@property (nonatomic, strong) SBPreview *preview;

@property (nonatomic, strong) NSString *leagueName;

@property (nonatomic, strong) NSString *moneyLine;
@property (nonatomic, strong) NSString *location;

@property (nonatomic, strong) NSNumber *homeScore;
@property (nonatomic, strong) NSNumber *awayScore;
@property (nonatomic, strong) NSString *boxscoreId;
@property (nonatomic, strong) NSString *previewId;

@property (nonatomic, strong) NSString *timeRemaining;
@property (nonatomic, strong) NSString *currentPeriod;

@property (nonatomic, strong) NSString *state;
@property (nonatomic, strong) NSString *endedIn;
@property (nonatomic, strong) NSDate *startTime;

- (SBTeam *)winningTeam;
- (SBTeam *)teamFromDataName:(NSString *)dataName;

- (BOOL)isOver;
- (BOOL)isInProgress;
- (BOOL)isPregame;
- (BOOL)hasPreviewOrRecap;
- (BOOL)hasPreviewOrRecapPhoto;
- (NSString *)localStartTime;
- (NSString *)localStartTimeWithDate;
- (NSString *)homeScoreString;
- (NSString *)awayScoreString;
- (int)favoriteScore;

- (void)findBoxscore:(NSDictionary *)paramaters
            success:(void (^) (SBBoxscore *))success
            failure:(void (^) (NSError *error))failure;

- (void)findPreview:(NSDictionary *)paramaters
            success:(void (^) (SBPreview *))success
            failure:(void (^) (NSError *error))failure;

- (void)findSchedules:(NSDictionary *)paramaters
            success:(void (^) (NSArray *))success
            failure:(void (^) (NSError *error))failure;
@end