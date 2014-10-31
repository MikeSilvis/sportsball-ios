//
//  CSStickyParallaxHeaderViewController.m
//  CSStickyHeaderFlowLayoutDemo
//
//  Created by James Tang on 6/4/14.
//  Copyright (c) 2014 Jamz Tang. All rights reserved.
//

#import "ScoreIndex2CollectionViewController.h"
#import "CSCell.h"
#import "CSStickyHeaderFlowLayout.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "Team.h"
#import "Game.h"

@implementation ScoreIndex2CollectionViewController


- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self dummyData];
        self.headerNib = [UINib nibWithNibName:@"LeagueHeader" bundle:nil];
    }
    return self;
}

-(void)dummyData {
  Team *awayTeam = [[Team alloc] init];
  awayTeam.name = @"Panthers";
  awayTeam.logoUrl = [NSURL URLWithString:@"http://upload.wikimedia.org/wikipedia/ang/c/cd/Panthers_tacn.png"];
  awayTeam.wins = @4;
  awayTeam.loses = @3;

  Team *homeTeam = [[Team alloc] init];
  homeTeam.name = @"Penguins";
  homeTeam.logoUrl = [NSURL URLWithString:@"http://img4.wikia.nocookie.net/__cb20100914172946/logopedia/images/0/00/200px-Pittsburgh_Penguins_logo_1972-1992_svg.png"];
  homeTeam.wins = @6;
  homeTeam.loses = @1;

  Game *game1 = [[Game alloc] init];
  game1.awayTeam = awayTeam;
  game1.homeTeam = homeTeam;

  self.games = @[
                 game1,
                 game1,
                 game1,
                 game1,
                 game1,
                 game1,
                 game1,
                 game1,
                 game1
                ];
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    CSStickyHeaderFlowLayout *layout = (id)self.collectionViewLayout;

    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"nhl-background"]];
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
  CSCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"gameViewCell" forIndexPath:indexPath];

  Game *currentGame = self.games[indexPath.row];

  // Home Team
  Team *homeTeam = currentGame.homeTeam;
  cell.homeTeamName.text = homeTeam.name;
  [cell.homeTeamLogo sd_setImageWithURL:homeTeam.logoUrl placeholderImage:nil];
//  cell.homeTeamScore.text = @"5";

  // Away Team
  Team *awayTeam = currentGame.awayTeam;
  cell.awayTeamName.text = awayTeam.name;
  [cell.awayTeamLogo sd_setImageWithURL:awayTeam.logoUrl placeholderImage:nil];
//  cell.awayTeamScore.text = @"3";

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
