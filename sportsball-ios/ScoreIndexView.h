//
//  ScoreIndexView.h
//  sportsball-ios
//
//  Created by Mike Silvis on 11/6/14.
//  Copyright (c) 2014 Mike Silvis. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "League.h"

@interface ScoreIndexView : UIView <UICollectionViewDataSource, UICollectionViewDelegate>

@property (nonatomic, retain) League *league;

@end
