//
//  Team.h
//  sportsball-ios
//
//  Created by Mike Silvis on 10/31/14.
//  Copyright (c) 2014 Mike Silvis. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Team : NSObject

@property (nonatomic, retain) NSURL *logoUrl;
@property (nonatomic, retain) NSString *name;
@property (nonatomic, retain) NSNumber *wins;
@property (nonatomic, retain) NSNumber *loses;

-(id)initWithJson:(id)json;
-(NSString *)formattedRecord;
@end
