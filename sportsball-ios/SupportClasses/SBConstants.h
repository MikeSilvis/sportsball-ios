//
//  SBConstants.h
//  sportsball-ios
//
//  Created by Mike Silvis on 4/4/15.
//  Copyright (c) 2015 Mike Silvis. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

extern NSString *const kPlaceholderImageSize;
extern NSString *const kPlaceholderImage;
extern NSString *const kNotificationHideEvent;

extern CGFloat kHeaderSize;

@interface SBConstants : NSObject

+ (SBConstants *)sharedInstance;
- (NSString *)getSecretValueFrom:(NSString *)key;

@end
