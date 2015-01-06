//
//  RecapCollectionViewCell.m
//  sportsball-ios
//
//  Created by Mike Silvis on 12/23/14.
//  Copyright (c) 2014 Mike Silvis. All rights reserved.
//

#import "RecapCollectionViewCell.h"
#import <UIImageView+AFNetworking.h>
#import <UIImage+Blur.h>

@implementation RecapCollectionViewCell

-(void)awakeFromNib {
  [super awakeFromNib];

  self.backgroundColor = [UIColor clearColor];
  self.headerImage.clipsToBounds = YES;
}

-(void)setRecap:(Recap *)recap {
  _recap = recap;

  self.headline.text = recap.headline;
  self.content.text = recap.content;
  [self.headerImage setImageWithURL:recap.photoURL];
}

+(CGSize)measureCellSizeWithResource:(Game *)resource andWidth:(CGFloat)width {
  if (resource.isOver) {
    return CGSizeMake(width, 320);
  }
  else {
    return CGSizeZero;
  }
}

@end
