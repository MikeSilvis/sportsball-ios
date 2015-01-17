//
//  UIImage+Resize.m
//  sportsball-ios
//
//  Created by Mike Silvis on 12/17/14.
//  Copyright (c) 2014 Mike Silvis. All rights reserved.
//

#import "UIImage+Resize.h"

@implementation UIImage (Resize)

-(UIImage *)resizeImage:(UIImage*)image newSize:(CGSize)newSize {
  CGRect newRect = CGRectIntegral(CGRectMake(0, 0, newSize.width, newSize.height));
  CGImageRef imageRef = image.CGImage;

  UIGraphicsBeginImageContextWithOptions(newSize, NO, 0);
  CGContextRef context = UIGraphicsGetCurrentContext();

  // Set the quality level to use when rescaling
  CGContextSetInterpolationQuality(context, kCGInterpolationHigh);
  CGAffineTransform flipVertical = CGAffineTransformMake(1, 0, 0, -1, 0, newSize.height);

  CGContextConcatCTM(context, flipVertical);  
  // Draw into the context; this scales the image
  CGContextDrawImage(context, newRect, imageRef);

  // Get the resized image from the context and a UIImage
  CGImageRef newImageRef = CGBitmapContextCreateImage(context);
  UIImage *newImage = [UIImage imageWithCGImage:newImageRef];

  CGImageRelease(newImageRef);
  UIGraphicsEndImageContext();    

  return newImage;
}

@end
