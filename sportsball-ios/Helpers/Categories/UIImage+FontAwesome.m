//
//  UIImage+FontAwesome.m
//  sportsball-ios
//
//  Created by Mike Silvis on 11/8/14.
//  Copyright (c) 2014 Mike Silvis. All rights reserved.
//

#import "UIImage+FontAwesome.h"
#import "EDColor.h"

@implementation UIImage (FontAwesome)

+(UIImage *)imageWithFontAwesomeIcon:(FAKFontAwesome *)icon andSize:(CGFloat)iconSize andColor:(NSString *)colorString {
  UIColor *color = [UIColor colorWithHexString:colorString];;
  [icon addAttribute:NSForegroundColorAttributeName value:color];
  return [icon imageWithSize:CGSizeMake(iconSize, iconSize)];
}

@end
