//
//  Game.h
//  sportsball-ios
//
//  Created by Mike Silvis on 10/31/14.
//  Copyright (c) 2014 Mike Silvis. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Champion.h"
#import "Team.h"
#import "Boxscore.h"
#import "Preview.h"

@interface Game : Champion

@property (nonatomic, strong) Team *awayTeam;
@property (nonatomic, strong) Team *homeTeam;
@property (nonatomic, strong) Boxscore *boxscore;
@property (nonatomic, strong) Preview *preview;

@property (nonatomic, strong) NSString *league;

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

@property (nonatomic, strong) NSDateFormatter *df;

-(Team *)winningTeam;
-(Team *)teamFromDataName:(NSString *)dataName;

-(BOOL)isOver;
-(BOOL)isInProgress;
-(BOOL)isPregame;
-(NSString *)localStartTime;
-(NSString *)homeScoreString;
-(NSString *)awayScoreString;

-(void)findBoxscore:(NSDictionary *)paramaters
            success:(void (^) (Boxscore *))success
            failure:(void (^) (NSError *error))failure;

-(void)findPreview:(NSDictionary *)paramaters
            success:(void (^) (Preview *))success
            failure:(void (^) (NSError *error))failure;
@end