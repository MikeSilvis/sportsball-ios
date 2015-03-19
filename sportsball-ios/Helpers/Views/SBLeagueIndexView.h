//
//  SBLeagueIndexView.h
//  sportsball-ios
//
//  Created by Mike Silvis on 3/18/15.
//  Copyright (c) 2015 Mike Silvis. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SBGame.h"
#import "SBTeam.h"

@protocol SBScoreIndexViewDelegate <NSObject>

- (void)selectedGame:(SBGame *)game;
- (void)askForFavoriteTeam:(SBTeam *)team;
- (void)requestFailed:(NSError *)error;

@end

@interface SBLeagueIndexView : UIView

@property (nonatomic, weak) id<SBScoreIndexViewDelegate> delegate;

@end
