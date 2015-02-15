//
//  UIImage+colorImage.m
//  sportsball-ios
//
//  Created by Mike Silvis on 2/15/15.
//  Copyright (c) 2015 Mike Silvis. All rights reserved.
//

#import "UIImage+ColorImage.h"

@implementation UIImage (ColorImage)

+ (UIImage *)colorizeImage:(UIImage *)image withColor:(UIColor *)color {
    UIGraphicsBeginImageContext(image.size);

    CGContextRef context = UIGraphicsGetCurrentContext();
    CGRect area = CGRectMake(0, 0, image.size.width, image.size.height);

    CGContextScaleCTM(context, 1, -1);
    CGContextTranslateCTM(context, 0, -area.size.height);

    CGContextSaveGState(context);
    CGContextClipToMask(context, area, image.CGImage);

    [color set];
    CGContextFillRect(context, area);

    CGContextRestoreGState(context);

    CGContextSetBlendMode(context, kCGBlendModeMultiply);

    CGContextDrawImage(context, area, image.CGImage);

    UIImage *colorizedImage = UIGraphicsGetImageFromCurrentImageContext();

    UIGraphicsEndImageContext();

    return colorizedImage;
}

@end
