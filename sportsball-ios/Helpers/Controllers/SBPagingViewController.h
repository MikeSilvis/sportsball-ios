//
//  SBPagingViewController.h
//  sportsball-ios
//
//  Created by Mike Silvis on 3/28/15.
//  Copyright (c) 2015 Mike Silvis. All rights reserved.
//

#import "SBViewController.h"

@protocol SBPagingViewDelegate <NSObject>

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath;
- (void)defineCells:(UICollectionView *)collectionView;
- (void)cellDidAppear:(UICollectionViewCell *)cell;
- (void)cellDidDisappear:(UICollectionViewCell *)cell;

@end

@interface SBPagingViewController : SBViewController <UICollectionViewDataSource, UICollectionViewDelegate>

@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (weak, nonatomic) IBOutlet UIPageControl *pageControl;
@property (weak, nonatomic) IBOutlet UIToolbar *toolBar;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *hamburgerButton;
- (IBAction)hamburgerClicked:(id)sender;

@property (nonatomic, weak) id<SBPagingViewDelegate> delegate;

@end
