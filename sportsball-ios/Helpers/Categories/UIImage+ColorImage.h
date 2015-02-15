//
//  UIImage+colorImage.h
//  sportsball-ios
//
//  Created by Mike Silvis on 2/15/15.
//  Copyright (c) 2015 Mike Silvis. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface UIImage (ColorImage)

+ (UIImage *)colorizeImage:(UIImage *)image withColor:(UIColor *)color;

@end
