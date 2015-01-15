//
//  Champion.h
//  sportsball-ios
//
//  Created by Mike Silvis on 11/6/14.
//  Copyright (c) 2014 Mike Silvis. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AFNetworking/AFHTTPRequestOperationManager.h>

@interface SportsBallModel : NSObject

@property (nonatomic, strong) NSDateFormatter *dateFormatter;
@property (nonatomic, strong) NSDateFormatter *localStartTimeDf;

-(id)initWithJson:(id)json;

+(void)dispatchRequest:(NSString *)path
            parameters:(id)parameters
               success:(void (^) (id responseObject))success
               failure:(void (^) (NSError *error))failure;

-(void)dispatchRequest:(NSString *)path
            parameters:(id)parameters
               success:(void (^) (id responseObject))success
               failure:(void (^) (NSError *error))failure;

-(NSURL *)imageURL:(NSURL *)url withSize:(NSString *)size;

@end
