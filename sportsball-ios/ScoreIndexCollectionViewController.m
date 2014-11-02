//
//  CSStickyParallaxHeaderViewController.m
//  CSStickyHeaderFlowLayoutDemo
//
//  Created by James Tang on 6/4/14.
//  Copyright (c) 2014 Jamz Tang. All rights reserved.
//

#import "ScoreIndexCollectionViewController.h"
#import "GameOverCell.h"
#import "CSStickyHeaderFlowLayout.h"
#import "EDColor.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "Team.h"
#import "Game.h"
#import "UIImage+Blur.h"
#import <FontAwesomeKit/FAKFontAwesome.h>
#import <AFNetworking/AFHTTPRequestOperationManager.h>

@implementation ScoreIndexCollectionViewController


- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
//        [self dummyData];
        self.games = [NSMutableArray array];
        [self findGames];
        self.headerNib = [UINib nibWithNibName:@"LeagueHeader" bundle:nil];
    }
    return self;
}

//-(void)dummyData {
//  Team *awayTeam = [[Team alloc] init];
//  awayTeam.name = @"Florida";
//  awayTeam.logoUrl = [NSURL URLWithString:@"http://upload.wikimedia.org/wikipedia/ang/c/cd/Panthers_tacn.png"];
//  awayTeam.wins = @4;
//  awayTeam.loses = @3;
//
//  Team *homeTeam = [[Team alloc] init];
//  homeTeam.name = @"Pittsburgh";
//  homeTeam.logoUrl = [NSURL URLWithString:@"http://img4.wikia.nocookie.net/__cb20100914172946/logopedia/images/0/00/200px-Pittsburgh_Penguins_logo_1972-1992_svg.png"];
//  homeTeam.wins = @6;
//  homeTeam.loses = @1;
//
//  Game *game1 = [[Game alloc] init];
//  game1.awayTeam = awayTeam;
//  game1.awayScore = @3;
//  game1.homeTeam = homeTeam;
//  game1.homeScore = @5;
//
//  self.games = [NSMutableArray array];
//}

-(void)findGames {
  NSString *url = @"http://sportsball.herokuapp.com/api/scores/nhl";
  [[AFHTTPRequestOperationManager manager] GET:url parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
    for (id score in responseObject[@"scores"]) {
      Game *newGame = [[Game alloc] initWithJson:score];
        [self.games addObject:newGame];
    }
    [self.collectionView reloadData];
  } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
      NSLog(@"Error: %@", error);
  }];
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    CSStickyHeaderFlowLayout *layout = (id)self.collectionViewLayout;

    // jpeg quality image data
    float quality = .00001f;

    // intensity of blurred
    float blurred = 1.1f;

    NSData *imageData = UIImageJPEGRepresentation([UIImage imageNamed:@"nhl-background"], quality);
    UIImage *blurredImage = [[UIImage imageWithData:imageData] blurredImage:blurred];
    self.view.backgroundColor = [UIColor colorWithPatternImage:blurredImage];


    self.collectionView.backgroundColor = [UIColor clearColor];

    if ([layout isKindOfClass:[CSStickyHeaderFlowLayout class]]) {
        layout.parallaxHeaderReferenceSize = CGSizeMake(self.view.frame.size.width, 200);
        layout.parallaxHeaderMinimumReferenceSize = CGSizeMake(self.view.frame.size.width, 64);
        layout.itemSize = CGSizeMake(self.view.frame.size.width, layout.itemSize.height);
        layout.parallaxHeaderAlwaysOnTop = YES;

        // If we want to disable the sticky header effect
        layout.disableStickyHeaders = YES;
    }


    // Also insets the scroll indicator so it appears below the search bar
    self.collectionView.scrollIndicatorInsets = UIEdgeInsetsMake(0, 0, 0, 0);

    [self.collectionView registerNib:self.headerNib
          forSupplementaryViewOfKind:CSStickyHeaderParallaxHeader
                 withReuseIdentifier:@"header"];

}

#pragma mark UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return [self.games count];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
  GameOverCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"gameViewCell" forIndexPath:indexPath];

  CALayer *upperBorder = [CALayer layer];
  upperBorder.backgroundColor = [[UIColor grayColor] CGColor];

  CGFloat totalWidth = CGRectGetWidth(cell.frame);
  CGFloat width = totalWidth * 0.98;
  upperBorder.frame = CGRectMake((totalWidth - width) / 2, 0, width, 1.0f);
  [cell.layer addSublayer:upperBorder];

  CGFloat iconSize = 15;
  FAKFontAwesome *carretIcon = [FAKFontAwesome caretLeftIconWithSize:iconSize];
  UIColor *carretColor = [UIColor colorWithHexString:@"#c4eefe"];;
  [carretIcon addAttribute:NSForegroundColorAttributeName value:carretColor];
  UIImage *iconImage = [carretIcon imageWithSize:CGSizeMake(iconSize, iconSize)];
  cell.awayWinnerImage.image = iconImage;
  cell.homeWinnerImage.image = iconImage;

  Game *currentGame = self.games[indexPath.row];

  // Home Team
  Team *homeTeam = currentGame.homeTeam;
  cell.homeTeamName.text = homeTeam.name;
  cell.homeScore.text = [NSString stringWithFormat:@"%@", currentGame.homeScore];
  cell.homeWinnerImage.hidden = ![currentGame.winningTeam isEqual:homeTeam];
  cell.homeRecord.text = homeTeam.formattedRecord;
  [cell.homeTeamLogo sd_setImageWithURL:homeTeam.logoUrl placeholderImage:nil];

  // Away Team
  Team *awayTeam = currentGame.awayTeam;
  cell.awayTeamName.text = awayTeam.name;
  cell.awayScore.text = [NSString stringWithFormat:@"%@", currentGame.awayScore];
  cell.awayWinnerImage.hidden = ![currentGame.winningTeam isEqual:awayTeam];
  cell.awayRecord.text = awayTeam.formattedRecord;
  [cell.awayTeamLogo sd_setImageWithURL:awayTeam.logoUrl placeholderImage:nil];

  cell.timeRemaining.text = currentGame.timeRemaining;

  if (!currentGame.isOver) {
    cell.awayWinnerImage.hidden = YES;
    cell.homeWinnerImage.hidden = YES;
    cell.timeRemaining.hidden = NO;
    cell.timeRemaining.text = currentGame.timeRemaining;
    cell.currentPeriod.text = currentGame.currentPeriod;
  } else {
    cell.currentPeriod.text = @"Final";
    cell.timeRemaining.hidden = YES;
  }

  return cell;
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    UICollectionReusableView *cell = [collectionView dequeueReusableSupplementaryViewOfKind:kind
                                                                        withReuseIdentifier:@"header"
                                                                               forIndexPath:indexPath];

    return cell;
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}



@end
