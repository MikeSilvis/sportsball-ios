//
//  CSStickyParallaxHeaderViewController.m
//  CSStickyHeaderFlowLayoutDemo
//
//  Created by James Tang on 6/4/14.
//  Copyright (c) 2014 Jamz Tang. All rights reserved.
//

#import "ScoreIndexCollectionViewController.h"
#import "CSStickyHeaderFlowLayout.h"
#import "EDColor.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "Team.h"
#import "Game.h"
#import "UIImage+Blur.h"
#import <FontAwesomeKit/FAKFontAwesome.h>
#import <AFNetworking/AFHTTPRequestOperationManager.h>
#import <MRProgress/MRProgressOverlayView+AFNetworking.h>

//#define SERVER_URL @"http://localhost:3000/api/scores/nhl"
#define SERVER_URL @"http://sportsball.herokuapp.com/api/scores/nhl"

@implementation ScoreIndexCollectionViewController

- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];

    if (self) {
        self.games = [NSMutableArray array];
        self.headerNib = [UINib nibWithNibName:@"LeagueHeader" bundle:nil];
    }

    return self;
}

-(void)cancelTimer {
  [self.scorePuller invalidate];
}

-(void)startTimer {
  [self findGames:YES];
  self.scorePuller = [NSTimer scheduledTimerWithTimeInterval:30 target:self selector:@selector(findGames:) userInfo:nil repeats:YES];
}

-(void)viewDidDisappear:(BOOL)animated {
  [super viewDidDisappear:animated];
  [self cancelTimer];
}

-(void)findGames:(BOOL)showLoader {
  NSDateFormatter *df = [[NSDateFormatter alloc] init];
  [df setDateFormat:@"yyyy-MM-dd"];
  NSDictionary *params = @{@"date": [df stringFromDate:[NSDate date]]};
  self.games = [NSMutableArray array];

  if (showLoader) {
    [MRProgressOverlayView showOverlayAddedTo:self.view animated:YES];
  }

  [[AFHTTPRequestOperationManager manager] GET:SERVER_URL parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
    for (id score in responseObject[@"scores"]) {
        Game *newGame = [[Game alloc] initWithJson:score];
        [self.games addObject:newGame];
    }
    [self.collectionView reloadData];
    if (showLoader) {
      [MRProgressOverlayView dismissOverlayForView:self.view animated:YES];
    }
  } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
    NSLog(@"Error: %@", error);
    if (showLoader) {
      [MRProgressOverlayView dismissOverlayForView:self.view animated:YES];
    }
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

    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(cancelTimer)
                                                 name:UIApplicationDidEnterBackgroundNotification
                                               object:nil];

    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(startTimer)
                                                 name:UIApplicationDidBecomeActiveNotification
                                               object:nil];

}

#pragma mark UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return [self.games count];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
//  GameUICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"gameViewCell" forIndexPath:indexPath];
//  Game *currentGame = self.games[indexPath.row];
//  cell.currentGame = currentGame;
//
//  return cell;
  UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"gameViewCell" forIndexPath:indexPath];
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
