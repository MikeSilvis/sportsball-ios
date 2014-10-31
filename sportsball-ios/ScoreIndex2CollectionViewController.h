//
//  ScoreIndex2CollectionViewController.h
//  sportsball-ios
//
//  Created by Mike Silvis on 10/31/14.
//  Copyright (c) 2014 Mike Silvis. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ScoreIndex2CollectionViewController : UICollectionViewController

@property (nonatomic, strong) UINib *headerNib;

@property (nonatomic, retain) NSArray *games;

@end
