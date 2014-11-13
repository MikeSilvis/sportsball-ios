//
//  ScoreShowViewController.m
//  sportsball-ios
//
//  Created by Mike Silvis on 11/13/14.
//  Copyright (c) 2014 Mike Silvis. All rights reserved.
//

#import "ScoreShowViewController.h"
#import "CSStickyHeaderFlowLayout.h"

@implementation ScoreShowViewController

- (void)viewDidLoad {
  [super viewDidLoad];
  self.view.backgroundColor = [UIColor clearColor];

  UITapGestureRecognizer *backgroundRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(backgroundTapped:)];
  backgroundRecognizer.delegate = self;
  [self.view addGestureRecognizer:backgroundRecognizer];
}

-(void)viewWillAppear:(BOOL)animated {
  [super viewWillAppear:animated];

  // Set the collection view to be half the size of the frame
  CGRect f = self.collectionView.frame;
  f.size.height = self.view.bounds.size.height / 2;
  self.collectionView.frame = f;

  // Header
//  CGFloat headerSize = 74;
//  CSStickyHeaderFlowLayout *layout = (id)self.collectionView.collectionViewLayout;
//  layout.parallaxHeaderReferenceSize = CGSizeMake(self.bounds.size.width, headerSize);
//  layout.parallaxHeaderMinimumReferenceSize = CGSizeMake(self.bounds.size.width, headerSize);
//  layout.itemSize = CGSizeMake(self.frame.size.width, layout.itemSize.height);
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch {
  if ([touch.view isEqual:self.collectionView]) {
    return NO;
  }
  else {
    return YES;
  }
}

- (void)backgroundTapped:(UITapGestureRecognizer*)recognizer {
  [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)didRequestClose:(id)sender {
  [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark 

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
  return 0;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
//  GameCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:gameViewCell forIndexPath:indexPath];
//  cell.currentGame = currentGame;
//  return cell;

  UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"rabble" forIndexPath:indexPath];
  return cell;
}

@end
