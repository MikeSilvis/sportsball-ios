//
//  GameCollectionViewCell.m
//  sportsball-ios
//
//  Created by Mike Silvis on 11/6/14.
//  Copyright (c) 2014 Mike Silvis. All rights reserved.
//

#import "GameCollectionViewCell.h"
#import <FontAwesomeKit/FAKFontAwesome.h>
#import "EDColor.h"
#import <UIImageView+AFNetworking.h>
#import "UIImage+FontAwesome.h"

@implementation GameCollectionViewCell

-(void)awakeFromNib {
  self.backgroundColor = [UIColor clearColor];

  // Winner Image
  CGFloat iconSize = 15;
  FAKFontAwesome *carretIcon = [FAKFontAwesome caretLeftIconWithSize:iconSize];
  UIImage *iconImage = [UIImage imageWithFontAwesomeIcon:carretIcon andSize:iconSize andColor:@"#c4eefe"];
  self.awayTeamWinner.image = iconImage;
  self.homeTeamWinner.image = iconImage;
}

-(void)layoutSubviews {
  [super layoutSubviews];

  // Upper Border
  CALayer *upperBorder = [CALayer layer];
  upperBorder.backgroundColor = [[UIColor whiteColor] CGColor];
  CGFloat totalWidth = CGRectGetWidth(self.frame);
  CGFloat width = totalWidth;
  CGFloat widthOfBorder = 0.5f;
  upperBorder.frame = CGRectMake((totalWidth - width) / 2, self.bounds.size.height - widthOfBorder, width, widthOfBorder);
  upperBorder.opacity = 0.5f;
  [self.layer addSublayer:upperBorder];
}

-(void)setCurrentGame:(Game *)currentGame {
  _currentGame = currentGame;

  // Home Team
  Team *homeTeam = self.currentGame.homeTeam;
  self.homeTeamName.text = homeTeam.name;
  self.homeTeamScore.text = [NSString stringWithFormat:@"%@", self.currentGame.homeScore];
  self.homeTeamScore.text = self.currentGame.homeScoreString;
  self.homeTeamWinner.hidden = ![self.currentGame.winningTeam isEqual:homeTeam];
  self.homeTeamRecord.text = homeTeam.formattedRecord;
  [self.homeTeamLogo setImageWithURL:[homeTeam logoURLWithSize:@"60x60"]];

  // Away Team
  Team *awayTeam = self.currentGame.awayTeam;
  self.awayTeamName.text = awayTeam.name;
  self.awayTeamScore.text = self.currentGame.awayScoreString;
  self.awayTeamWinner.hidden = ![self.currentGame.winningTeam isEqual:awayTeam];
  self.awayTeamRecord.text = awayTeam.formattedRecord;
  [self.awayTeamLogo setImageWithURL:[awayTeam logoURLWithSize:@"60x60"]];

  self.upperInfo.text = self.currentGame.timeRemaining;

  if (self.currentGame.isPregame) {
    // Winner Image
    self.awayTeamWinner.hidden = YES;
    self.homeTeamWinner.hidden = YES;

    // Scores
    self.awayTeamScore.hidden = YES;
    self.homeTeamScore.hidden = YES;

    // Background
    self.upperInfo.hidden = NO;
    self.lowerInfo.hidden = NO;
    self.upperInfo.text = self.currentGame.localStartTime;
    self.lowerInfo.text = self.currentGame.moneyLine;
    self.lowerInfo.font = [UIFont fontWithName:@"Avenir" size:10];
  }
  else if (self.currentGame.isInProgress) {
    // Winner Image
    self.awayTeamWinner.hidden = YES;
    self.homeTeamWinner.hidden = YES;

    // Scores
    self.awayTeamScore.hidden = NO;
    self.homeTeamScore.hidden = NO;

    // Game Clock
    self.upperInfo.hidden = NO;
    self.lowerInfo.hidden = NO;
    self.lowerInfo.text = self.currentGame.timeRemaining;
    self.upperInfo.text = self.currentGame.currentPeriod;
  }
  else {
    // Scores
    self.homeTeamScore.hidden = NO;
    self.awayTeamScore.hidden = NO;

    // Game Summary
    self.lowerInfo.hidden = YES;
    self.upperInfo.hidden = NO;
    self.upperInfo.text = self.currentGame.endedIn;
  }

}

@end
