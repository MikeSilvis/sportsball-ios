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

+(UIImage *)imageWithFontAwesomeIcon:(FAKFontAwesome *)icon andSize:(CGFloat)iconSize andColor:(NSString *)color {
  UIColor *hamburgerColor = [UIColor colorWithHexString:color];;
  [icon addAttribute:NSForegroundColorAttributeName value:hamburgerColor];
  return [icon imageWithSize:CGSizeMake(iconSize, iconSize)];
}

@end
