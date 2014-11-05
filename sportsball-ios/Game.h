//
//  Game.h
//  sportsball-ios
//
//  Created by Mike Silvis on 10/31/14.
//  Copyright (c) 2014 Mike Silvis. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Team.h"

@interface Game : NSObject

@property (nonatomic, retain) Team *awayTeam;
@property (nonatomic, retain) Team *homeTeam;

@property (nonatomic, retain) NSString *league;

@property (nonatomic, retain) NSString *moneyLine;
@property (nonatomic, retain) NSString *location;

@property (nonatomic, retain) NSNumber *homeScore;
@property (nonatomic, retain) NSNumber *awayScore;


@property (nonatomic, retain) NSString *timeRemaining;
@property (nonatomic, retain) NSString *currentPeriod;

@property (nonatomic, retain) NSString *state;
@property (nonatomic, retain) NSString *endedIn;
@property (nonatomic, retain) NSDate *startTime;

@property (nonatomic, retain) NSDateFormatter *df;

-(Team *)winningTeam;
-(id)initWithJson:(id)json;

-(BOOL)isOver;
-(BOOL)isInProgress;
-(BOOL)isPregame;
-(NSString *)localStartTime;

@end
