//
//  ScoreShowHeader.m
//  sportsball-ios
//
//  Created by Mike Silvis on 11/23/14.
//  Copyright (c) 2014 Mike Silvis. All rights reserved.
//

#import "ScoreShowHeader.h"
#import "UIImage+FontAwesome.h"
#import <SDWebImage/UIImageView+WebCache.h>

@implementation ScoreShowHeader

-(void)awakeFromNib {
  [super awakeFromNib];
  self.backgroundColor = [UIColor clearColor];

  // Winner Image
  CGFloat iconSize = 15;
  FAKFontAwesome *carretIcon = [FAKFontAwesome caretLeftIconWithSize:iconSize];
  UIImage *iconImage = [UIImage imageWithFontAwesomeIcon:carretIcon andSize:iconSize andColor:@"#c4eefe"];
  self.homeTeamWinnerImage.image = iconImage;

  carretIcon = [FAKFontAwesome caretRightIconWithSize:iconSize];
  iconImage = [UIImage imageWithFontAwesomeIcon:carretIcon andSize:iconSize andColor:@"#c4eefe"];
  self.awayTeamWinnerImage.image = iconImage;
}

-(void)setGame:(Game *)game {
  _game = game;

  Team *homeTeam = self.game.homeTeam;
  [self.homeTeamLogo sd_setImageWithURL:homeTeam.logoUrl];
  self.homeTeamScore.text = self.game.homeScoreString;
  self.homeTeamWinnerImage.hidden = ![self.game.winningTeam isEqual:homeTeam];
  self.homeTeamScore.text = self.game.homeScoreString;

  Team *awayTeam = self.game.awayTeam;
  [self.awayTeamLogo sd_setImageWithURL:awayTeam.logoUrl];
  self.awayTeamWinnerImage.hidden = ![self.game.winningTeam isEqual:awayTeam];
  self.awayTeamScore.text = self.game.awayScoreString;

  if (self.game.isPregame) {
    // Winner Image
    self.awayTeamWinnerImage.hidden = YES;
    self.homeTeamWinnerImage.hidden = YES;

    // Scores
    self.awayTeamScore.hidden = YES;
    self.homeTeamScore.hidden = YES;

    // Background
    self.upperInfo.hidden = NO;
    self.lowerInfo.hidden = NO;
    self.upperInfo.text = self.game.localStartTime;
    self.lowerInfo.text = self.game.moneyLine;
  }
  else if (self.game.isInProgress) {
    // Winner Image
    self.awayTeamWinnerImage.hidden = YES;
    self.homeTeamWinnerImage.hidden = YES;

    // Scores
    self.awayTeamScore.hidden = NO;
    self.homeTeamScore.hidden = NO;

    // Game Clock
    self.upperInfo.hidden = NO;
    self.lowerInfo.hidden = NO;
    self.lowerInfo.text = self.game.timeRemaining;
    self.upperInfo.text = self.game.currentPeriod;
  }
  else {
    // Scores
    self.awayTeamScore.hidden = NO;
    self.homeTeamScore.hidden = NO;

    // Game Summary
    self.lowerInfo.hidden = NO;
    self.upperInfo.hidden = YES;
    self.lowerInfo.text = self.game.endedIn;
  }
}

@end
