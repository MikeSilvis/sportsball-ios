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
@property (nonatomic, retain) NSString *moneyLine;
@property (nonatomic, retain) NSString *location;

@end
