//
//  Champion.h
//  sportsball-ios
//
//  Created by Mike Silvis on 11/6/14.
//  Copyright (c) 2014 Mike Silvis. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AFNetworking/AFHTTPRequestOperationManager.h>

@interface Champion : NSObject

@property (nonatomic, strong) NSDateFormatter *dateFormatter;

-(id)initWithJson:(id)json;

+(void)dispatchRequest:(NSString *)path
            parameters:(id)parameters
               success:(void (^) (id responseObject))success
               failure:(void (^) (NSError *error))failure;

-(void)dispatchRequest:(NSString *)path
            parameters:(id)parameters
               success:(void (^) (id responseObject))success
               failure:(void (^) (NSError *error))failure;

-(NSURL *)imageURLWithSize:(NSURL *)url andSize:(NSString *)size;

@end
