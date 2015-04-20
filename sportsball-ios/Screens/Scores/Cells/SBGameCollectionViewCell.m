//
//  GameCollectionViewCell.m
//  sportsball-ios
//
//  Created by Mike Silvis on 11/6/14.
//  Copyright (c) 2014 Mike Silvis. All rights reserved.
//

#import "SBGameCollectionViewCell.h"
#import <FontAwesomeKit/FAKFontAwesome.h>
#import "UIImage+FontAwesome.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "SBUser.h"

@implementation SBGameCollectionViewCell

- (void)awakeFromNib {
  self.backgroundColor = [UIColor clearColor];

  // Winner Image
  CGFloat iconSize = 15;
  FAKFontAwesome *carretIcon = [FAKFontAwesome caretLeftIconWithSize:iconSize];
  UIImage *iconImage = [UIImage imageWithFontAwesomeIcon:carretIcon andSize:iconSize andColor:@"#c4eefe"];
  self.awayTeamWinner.image = iconImage;
  self.homeTeamWinner.image = iconImage;
}

- (void)layoutSubviews {
  [super layoutSubviews];

  // Lower Border
  CGFloat widthOfBorder = 1.0f;
  UIView *horizontalLine = [[UIView alloc] initWithFrame:CGRectMake(0, self.bounds.size.height - widthOfBorder, self.bounds.size.width, widthOfBorder)];
  horizontalLine.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0.5f];
  [self addSubview:horizontalLine];
}

- (void)setGame:(SBGame *)game {
  _game = game;

  // Home Team
  SBTeam *homeTeam = self.game.homeTeam;
  self.homeTeamName.text = homeTeam.name;
  self.homeTeamScore.text = [NSString stringWithFormat:@"%@", self.game.homeScore];
  self.homeTeamScore.text = self.game.homeScoreString;
  self.homeTeamWinner.hidden = ![self.game.winningTeam isEqual:homeTeam];
  self.homeTeamRecord.text = homeTeam.formattedRecord;
  self.homeTeamRank.text = homeTeam.rank;

  // Away Team
  SBTeam *awayTeam = self.game.awayTeam;
  self.awayTeamName.text = awayTeam.name;
  self.awayTeamScore.text = self.game.awayScoreString;
  self.awayTeamWinner.hidden = ![self.game.winningTeam isEqual:awayTeam];
  self.awayTeamRecord.text = awayTeam.formattedRecord;
  self.awayTeamRank.text = awayTeam.rank;

  // Logos
  if ([SBUser currentUser].teamLogos) {
    NSString *logoSize = @"40x40";
    [self.homeTeamLogo sd_setImageWithURL:[homeTeam imageURL:homeTeam.logoUrl withSize:logoSize]];
    [self.awayTeamLogo sd_setImageWithURL:[awayTeam imageURL:awayTeam.logoUrl withSize:logoSize]];
  }

  self.upperInfo.text = self.game.timeRemaining;

  if (self.game.isPregame) {
    // Winner Image
    self.awayTeamWinner.hidden = YES;
    self.homeTeamWinner.hidden = YES;

    // Scores
    self.awayTeamScore.hidden = YES;
    self.homeTeamScore.hidden = YES;

    // Background
    self.upperInfo.hidden = NO;
    self.lowerInfo.hidden = NO;
    self.upperInfo.text = self.game.localStartTime;
    self.lowerInfo.text = self.game.moneyLine;
    self.lowerInfo.font = [UIFont fontWithName:@"Avenir" size:10];
  }
  else if (self.game.isInProgress) {
    // Winner Image
    self.awayTeamWinner.hidden = YES;
    self.homeTeamWinner.hidden = YES;

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
    self.homeTeamScore.hidden = NO;
    self.awayTeamScore.hidden = NO;

    // Game Summary
    self.lowerInfo.hidden = YES;
    self.upperInfo.hidden = NO;
    self.upperInfo.text = self.game.endedIn;
  }

}

@end
