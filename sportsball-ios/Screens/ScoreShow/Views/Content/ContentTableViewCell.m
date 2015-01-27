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

- (void)awakeFromNib {
  [super awakeFromNib];

  self.backgroundColor = [UIColor clearColor];
  self.headerImage.clipsToBounds = YES;

  self.selectionStyle = UITableViewCellSelectionStyleNone;
}

- (void)setRecap:(SBRecap *)recap {
  _recap = recap;

  self.headline.text = self.recap.headline;
  self.content.text = self.recap.content;
  [self.headerImage setImageWithURL:self.recap.photoURL];

  if (recap.headline) {
    self.renderSeperator = YES;
    self.hidden = NO;
  }
  else {
    self.hidden = YES;
  }
}

- (void)setPreview:(SBPreview *)preview {
  _preview = preview;

  self.headline.text = self.preview.headline;
  self.content.text = self.preview.content;

  if (self.preview.headline) {
    self.renderSeperator = YES;
    self.hidden = NO;
  }
  else {
    self.hidden = YES;
  }
}

- (void)layoutSubviews {
  [super layoutSubviews];

  // TODO: Add support for images in preview
  if (self.preview) {
    self.headerImage.frame = CGRectMake(0, 0, 0, 0);
    self.headerImage.hidden = YES;

    CGRect f = self.headline.frame;
    f.origin.y = 0;
    self.headline.frame = f;

    f = self.content.frame;
    f.origin.y = CGRectGetMinY(self.headline.frame) + CGRectGetHeight(self.headline.frame) + 5;
    self.content.frame = f;
  }
}

+ (CGSize)measureCellSizeWithResource:(SBGame *)resource andWidth:(CGFloat)width {
  CGFloat height = resource.isOver ? 300 : 80;

  if (resource.hasPreviewOrRecap) {
    return CGSizeMake(width, height);
  }

  return CGSizeZero;
}

@end
