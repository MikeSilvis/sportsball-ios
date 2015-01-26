//
//  UIImage+FontAwesome.h
//  sportsball-ios
//
//  Created by Mike Silvis on 11/8/14.
//  Copyright (c) 2014 Mike Silvis. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <FontAwesomeKit/FAKFontAwesome.h>

@interface UIImage (FontAwesome)

+ (UIImage *)imageWithFontAwesomeIcon:(FAKFontAwesome *)icon andSize:(CGFloat)iconSize andColor:(NSString *)colorString;

@end
