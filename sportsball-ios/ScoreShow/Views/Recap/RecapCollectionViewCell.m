//
//  RecapCollectionViewCell.m
//  sportsball-ios
//
//  Created by Mike Silvis on 12/23/14.
//  Copyright (c) 2014 Mike Silvis. All rights reserved.
//

#import "RecapCollectionViewCell.h"

@implementation RecapCollectionViewCell

-(void)awakeFromNib {
  [super awakeFromNib];

  self.backgroundColor = [UIColor clearColor];

  // Background Touch (for closing the modal)
  UITapGestureRecognizer *backgroundRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(backgroundTapped:)];
  backgroundRecognizer.delegate = self;
  [self addGestureRecognizer:backgroundRecognizer];
}

-(void)setRecap:(Recap *)recap {
  _recap = recap;

  self.headline.text = recap.headline;
  self.content.text = recap.content;
}

+(CGSize)measureCellSizeWithResource:(Recap *)resource andWidth:(CGFloat)width {
  return CGSizeMake(width, 100);
}

- (void)backgroundTapped:(UITapGestureRecognizer*)recognizer {
}

@end
