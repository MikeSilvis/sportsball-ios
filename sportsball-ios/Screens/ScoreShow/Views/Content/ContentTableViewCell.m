//
//  RecapCollectionViewCell.m
//  sportsball-ios
//
//  Created by Mike Silvis on 12/23/14.
//  Copyright (c) 2014 Mike Silvis. All rights reserved.
//

#import "ContentTableViewCell.h"
#import <UIImageView+AFNetworking.h>
#import <UIImage+Blur.h>

@implementation ContentTableViewCell

-(void)awakeFromNib {
  [super awakeFromNib];

  self.backgroundColor = [UIColor clearColor];
  self.headerImage.clipsToBounds = YES;

  self.selectionStyle = UITableViewCellSelectionStyleNone;
}

-(void)setRecap:(Recap *)recap {
  _recap = recap;

  self.headline.text = recap.headline;
  self.content.text = recap.content;
  [self.headerImage setImageWithURL:recap.photoURL];
}

-(void)setPreview:(Preview *)preview {
  _preview = preview;

  self.headline.text = preview.headline;
  self.content.text = preview.content;
}

-(void)layoutSubviews {
  [super layoutSubviews];

  // TODO: Add support for images in preview
  if (self.preview) {
    self.headerImage.frame = CGRectMake(0, 0, 0, 0);
    self.headerImage.hidden = YES;

    CGRect f = self.headline.frame;
    f.origin.y = 0;
    self.headline.frame = f;

    f = self.content.frame;
    f.origin.y = self.headline.frame.origin.y + self.headline.frame.size.height + 5;
    self.content.frame = f;
  }

}

+(CGSize)measureCellSizeWithResource:(Game *)resource andWidth:(CGFloat)width {
  if (resource.isOver) {
    return CGSizeMake(width, 300);
  }
  else if (resource.isPregame) {
    return CGSizeMake(width, 80);
  }
  else {
    return CGSizeZero;
  }
}

@end
