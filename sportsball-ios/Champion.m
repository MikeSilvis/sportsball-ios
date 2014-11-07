//
//  Champion.m
//  sportsball-ios
//
//  Created by Mike Silvis on 11/6/14.
//  Copyright (c) 2014 Mike Silvis. All rights reserved.
//

#import "Champion.h"

@implementation Champion

-(NSString *)getPathFromString:(NSString *)path {
  return [NSString stringWithFormat:@"http://sportsball.herokuapp.com/api/%@", path];
}

-(void)dispatchRequest:(NSString *)path
            parameters:(id)parameters
               success:(void (^) (id responseObject))success
               failure:(void (^) (NSError *error))failure {

  NSString *url = [self getPathFromString:path];

  [[AFHTTPRequestOperationManager manager] GET:url parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
    success(responseObject);
  } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
    NSLog(@"error: %@", error);
    failure(error);
  }];
}

@end
