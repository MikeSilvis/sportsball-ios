//
//  CSCell.m
//  CSStickyHeaderFlowLayoutDemo
//
//  Created by Jamz Tang on 8/1/14.
//  Copyright (c) 2014 Jamz Tang. All rights reserved.
//

#import "GameOverCell.h"
#import <QuartzCore/QuartzCore.h>

@implementation GameOverCell

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
      self.layer.borderColor = [[UIColor blackColor] CGColor];
      self.layer.borderWidth = 5;
    }
    return self;
}


@end
