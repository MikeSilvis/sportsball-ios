//
//  Champion.m
//  sportsball-ios
//
//  Created by Mike Silvis on 11/6/14.
//  Copyright (c) 2014 Mike Silvis. All rights reserved.
//

#import "SBModel.h"
#import <objc/runtime.h>

@implementation SBModel

static NSString * const kServerURL = @"https://api.jumbotron.io/%@";
//static NSString * const kServerURL = @"http://localhost:3000/api/%@";

- (id)initWithJson:(id)json {
  [NSException raise:@"Should be handled in subclass" format:@"not relevant"];

  return nil;
}

- (void)encodeWithCoder:(NSCoder *)coder {
  for (NSString *prop in [self allPropertyNames]) {
    [coder encodeObject:[self valueForKey:prop] forKey:prop];
  }
}

- (id)initWithCoder:(NSCoder *)coder {
    self = [super init];

    if (self) {
      for (NSString *prop in [self allPropertyNames]) {
        [self setValue:[coder decodeObjectForKey:prop] forKey:prop];
      }
    }

    return self;
}

- (NSArray *)allPropertyNames {
    unsigned count;
    objc_property_t *properties = class_copyPropertyList([self class], &count);

    NSMutableArray *rv = [NSMutableArray array];

    unsigned i;
    for (i = 0; i < count; i++)
    {
        objc_property_t property = properties[i];
        NSString *name = [NSString stringWithUTF8String:property_getName(property)];
        [rv addObject:name];
    }

    free(properties);

    return rv;
}

+ (NSString *)getPathFromString:(NSString *)path {
  return [NSString stringWithFormat:kServerURL, path];
}

+ (void)dispatchRequest:(NSString *)path
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

- (void)dispatchRequest:(NSString *)path
            parameters:(id)parameters
               success:(void (^) (id responseObject))success
               failure:(void (^) (NSError *error))failure {

  [self.class dispatchRequest:path
                   parameters:parameters
                      success:success
                      failure:failure];
}

- (NSDateFormatter *)dateFormatter {
  if (!_dateFormatter) {
    _dateFormatter = [[NSDateFormatter alloc] init];
    [_dateFormatter setDateFormat:@"yyyy-MM-dd"];
  }

  return _dateFormatter;
}


- (NSDateFormatter *)localStartTimeDf {
  if (!_localStartTimeDf) {
    _localStartTimeDf = [[NSDateFormatter alloc] init];
    [_localStartTimeDf setDateFormat: @"h:mm a"];
    [_localStartTimeDf setTimeZone:[NSTimeZone localTimeZone]];
  }

  return _localStartTimeDf;
}

- (NSURL *)imageURL:(NSURL *)url withSize:(NSString *)size {
  return [NSURL URLWithString:[NSString stringWithFormat:@"%@?size=%@", url.absoluteString, size]];
}


@end
