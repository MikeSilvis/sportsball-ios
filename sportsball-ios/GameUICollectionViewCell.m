//
//  CSself.m
//  CSStickyHeaderFlowLayoutDemo
//
//  Created by Jamz Tang on 8/1/14.
//  Copyright (c) 2014 Jamz Tang. All rights reserved.
//

#import "GameUICollectionViewCell.h"
#import "EDColor.h"
#import <QuartzCore/QuartzCore.h>
#import <FontAwesomeKit/FAKFontAwesome.h>
#import <SDWebImage/UIImageView+WebCache.h>

@implementation GameUICollectionViewCell

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
      self.layer.borderColor = [[UIColor blackColor] CGColor];
      self.layer.borderWidth = 5;

      // Bottom Border
      CALayer *upperBorder = [CALayer layer];
      upperBorder.backgroundColor = [[UIColor whiteColor] CGColor];
      CGFloat totalWidth = CGRectGetWidth(self.frame);
      CGFloat width = totalWidth * 0.98;
      upperBorder.frame = CGRectMake((totalWidth - width) / 2, 0, width, 1.0f);
      [self.layer addSublayer:upperBorder];

      // Winner Image
      CGFloat iconSize = 15;
      FAKFontAwesome *carretIcon = [FAKFontAwesome caretLeftIconWithSize:iconSize];
      UIColor *carretColor = [UIColor colorWithHexString:@"#c4eefe"];;
      [carretIcon addAttribute:NSForegroundColorAttributeName value:carretColor];
      UIImage *iconImage = [carretIcon imageWithSize:CGSizeMake(iconSize, iconSize)];
      self.awayWinnerImage.image = iconImage;
      self.homeWinnerImage.image = iconImage;
    }
    return self;
}

-(void)setCurrentGame:(Game *)currentGame {
  _currentGame = currentGame;

  // Home Team
  Team *homeTeam = self.currentGame.homeTeam;
  self.homeTeamName.text = homeTeam.name;
  self.homeScore.text = [NSString stringWithFormat:@"%@", self.currentGame.homeScore];
  self.homeWinnerImage.hidden = ![self.currentGame.winningTeam isEqual:homeTeam];
  self.homeRecord.text = homeTeam.formattedRecord;
  [self.homeTeamLogo sd_setImageWithURL:homeTeam.logoUrl placeholderImage:nil];

  // Away Team
  Team *awayTeam = self.currentGame.awayTeam;
  self.awayTeamName.text = awayTeam.name;
  self.awayScore.text = [NSString stringWithFormat:@"%@", self.currentGame.awayScore];
  self.awayWinnerImage.hidden = ![self.currentGame.winningTeam isEqual:awayTeam];
  self.awayRecord.text = awayTeam.formattedRecord;
  [self.awayTeamLogo sd_setImageWithURL:awayTeam.logoUrl placeholderImage:nil];

  self.timeRemaining.text = self.currentGame.timeRemaining;

  if (self.currentGame.isPregame) {
    self.awayWinnerImage.hidden = YES;
    self.homeWinnerImage.hidden = YES;
    self.timeRemaining.hidden = YES;
    self.awayScore.hidden = YES;
    self.homeScore.hidden = YES;
    self.currentPeriod.text = self.currentGame.localStartTime;
  }
  else if (self.currentGame.isInProgress) {
    self.awayWinnerImage.hidden = YES;
    self.homeWinnerImage.hidden = YES;
    self.awayScore.hidden = NO;
    self.homeScore.hidden = NO;
    self.timeRemaining.hidden = NO;
    self.currentPeriod.hidden = NO;
    self.timeRemaining.text = self.currentGame.timeRemaining;
    self.currentPeriod.text = self.currentGame.currentPeriod;
  }
  else {
    self.timeRemaining.hidden = YES;
    self.currentPeriod.text = self.currentGame.endedIn;
  }

}

@end
