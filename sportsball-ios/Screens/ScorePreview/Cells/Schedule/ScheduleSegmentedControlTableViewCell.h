//
//  ScheduleSegmentedControlTableViewCell.h
//  sportsball-ios
//
//  Created by Mike Silvis on 1/15/15.
//  Copyright (c) 2015 Mike Silvis. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SBGame.h"

@protocol ScheduleSegmentedControlTableViewCellProtocol <NSObject>

-(void)changedTeam:(SBTeam *)updatedTeam;

@end

@interface ScheduleSegmentedControlTableViewCell : UITableViewHeaderFooterView

- (IBAction)indexChanged:(UISegmentedControl *)sender;
@property (weak, nonatomic) IBOutlet UISegmentedControl *segmentedControl;
@property (nonatomic, strong) SBGame *game;
@property (nonatomic, strong) SBTeam *selectedTeam;

+(CGSize)measureCellSizeWithResource:(SBGame *)resource andWidth:(CGFloat)width;
@property (nonatomic, assign) id<ScheduleSegmentedControlTableViewCellProtocol> delegate;

@end
