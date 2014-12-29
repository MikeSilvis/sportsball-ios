//
//  Champion.m
//  sportsball-ios
//
//  Created by Mike Silvis on 11/6/14.
//  Copyright (c) 2014 Mike Silvis. All rights reserved.
//

#import "Champion.h"

@implementation Champion

static NSString * const serverURL = @"https://getbaryab.com/api/%@";
//static NSString * const serverURL = @"http://localhost:3000/api/%@";

-(id)initWithJson:(id)json {
  [NSException raise:@"Should be handled in subclass" format:@"not relevant"];

  return nil;
}

+(NSString *)getPathFromString:(NSString *)path {
  return [NSString stringWithFormat:serverURL, path];
}

+(void)dispatchRequest:(NSString *)path
            parameters:(id)parameters
               success:(void (^) (id responseObject))success
               failure:(void (^) (NSError *error))failure {

  NSString *url = [self getPathFromString:path];

  if (!parameters) {
    parameters = @{};
  }

  NSLog(@"making request with path: %@", path);

  [[AFHTTPRequestOperationManager manager] GET:url parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
    success(responseObject);
  } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
    if (failure) {
      failure(error);
    }
    NSLog(@"error: %@", error);
  }];
}

-(void)dispatchRequest:(NSString *)path
            parameters:(id)parameters
               success:(void (^) (id responseObject))success
               failure:(void (^) (NSError *error))failure {

  [self.class dispatchRequest:path
                   parameters:parameters
                      success:success
                      failure:failure];
}

-(NSDateFormatter *)dateFormatter {
  if (!_dateFormatter) {
    _dateFormatter = [[NSDateFormatter alloc] init];
    [_dateFormatter setDateFormat:@"yyyy-MM-dd"];
  }

  return _dateFormatter;
}

-(NSURL *)imageURLWithSize:(NSURL *)url andSize:(NSString *)size {
  return [NSURL URLWithString:[NSString stringWithFormat:@"%@?size=%@", url.absoluteString, size]];
}


@end
