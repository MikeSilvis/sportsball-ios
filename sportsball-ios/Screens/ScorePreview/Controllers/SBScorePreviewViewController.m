//
//  ScorePreviewViewController.m
//  sportsball-ios
//
//  Created by Mike Silvis on 1/8/15.
//  Copyright (c) 2015 Mike Silvis. All rights reserved.
//

#import "SBScorePreviewViewController.h"
#import "UIImage+FontAwesome.h"
#import <UIImageView+AFNetworking.h>
#import "SBContentTableViewCell.h"
#import "SBScoreDataTableViewCell.h"
#import "SBScheduleTableViewCell.h"
#import <CSNotificationView.h>
#import "SBUser.h"
#import "SBSchedule.h"

@interface SBScorePreviewViewController ()

@property BOOL shouldRenderTable;

@end

@implementation SBScorePreviewViewController

// Cell Identifiers
static NSString *kScoreContentCell = @"ScoreContentCell";
static NSString *kScoreDataCell = @"ScoreDataCell";
static NSString *kScheduleCell = @"scheduleTableViewCell";

// Cell Headers
static NSString *kSegmentedScheduleHeaderCell = @"kSegmentedScheduleHeaderCell";

// Cell Locations
// First Section
static const NSInteger kScoreRecapViewLocation = 0;
static const NSInteger kScoreDataViewLocation = 1;
// Second Section
static const NSInteger kScheduleCellLocation = 0;

- (void)viewDidLoad {
  [super viewDidLoad];

  // Collection View Styles
  self.tableView.backgroundColor = [UIColor clearColor];
  self.tableView.indicatorStyle = UIScrollViewIndicatorStyleWhite;
  self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;

  // Register nibs
  [self.tableView registerNib:[UINib nibWithNibName:@"SBContentTableViewCell" bundle:nil]
       forCellReuseIdentifier:kScoreContentCell];
  [self.tableView registerNib:[UINib nibWithNibName:@"SBScoreDataTableViewCell" bundle:nil]
       forCellReuseIdentifier:kScoreDataCell];
  [self.tableView registerNib:[UINib nibWithNibName:@"SBScheduleTableViewCell" bundle:nil]
       forCellReuseIdentifier:kScheduleCell];

  [self.tableView registerNib:[UINib nibWithNibName:@"SBScheduleSegmentedControlTableViewCell" bundle:nil] forHeaderFooterViewReuseIdentifier:kSegmentedScheduleHeaderCell];

  // Close Icon
  CGFloat iconSize = 25;
  FAKFontAwesome *closeIcon = [FAKFontAwesome timesIconWithSize:iconSize];
  [self.closeButton setImage:[UIImage imageWithFontAwesomeIcon:closeIcon andSize:iconSize andColor:@"#fff"] forState:UIControlStateNormal];
  [self.closeButton setTitle:@"" forState:UIControlStateNormal];
  [self.closeButton addTarget:self action:@selector(closeModal) forControlEvents:UIControlEventTouchDown];

  self.loadingIndicator.hidden = YES;
  self.shouldRenderTable = NO;

  // Logo clicked
  UITapGestureRecognizer *awayTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickedAwayLogo)];
  awayTap.numberOfTapsRequired = 1;
  [self.awayTeamLogo setUserInteractionEnabled:YES];
  [self.awayTeamLogo addGestureRecognizer:awayTap];

  UITapGestureRecognizer *homeTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickedHomeLogo)];
  homeTap.numberOfTapsRequired = 1;
  [self.homeTeamLogo setUserInteractionEnabled:YES];
  [self.homeTeamLogo addGestureRecognizer:homeTap];
}

- (void)clickedAwayLogo{
  [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:1] atScrollPosition:UITableViewScrollPositionTop animated:YES];
  [self changedTeam:self.game.awayTeam];
}

- (void)clickedHomeLogo {
  [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:1] atScrollPosition:UITableViewScrollPositionTop animated:YES];
  [self changedTeam:self.game.homeTeam];
}

- (void)viewWillAppear:(BOOL)animated {
  [super viewWillAppear:animated];
  self.loadingIndicator.hidden = NO;

  if (!self.game.previewId) {
    [self findSchedule];
  }
  else {
    [self findPreview];
  }

  [self setHeaderInfo];
}

- (void)findSchedule {
  NSDictionary *params = @{
                           @"teams" : @[
                                         self.game.awayTeam.dataName,
                                         self.game.homeTeam.dataName
                                       ],
                          };

  [self.game findSchedules:params success:^(NSArray *schedules) {
    SBPreview *preview = [[SBPreview alloc] init];
    preview.awayTeamSchedule = [schedules firstObject];
    preview.homeTeamSchedule = [schedules lastObject];

    self.game.preview = preview;

    [self setDataLoaded];
  } failure:^(NSError *error) {
  }];

}

- (void)findPreview {
  [self.game findPreview:nil success:^(SBPreview *preview) {
    self.game.preview = preview;

    [self setDataLoaded];
  } failure:^(NSError *error) {
    [CSNotificationView showInViewController:self style:CSNotificationViewStyleError message:[[SBUser currentUser] networkConnectionErrorMessage:error]];
  }];
}

- (void)setDataLoaded {
  self.shouldRenderTable = YES;
  self.loadingIndicator.hidden = YES;
  [self.tableView reloadData];
}

- (void)closeModal {
  [self dismissViewControllerAnimated:YES completion:nil];
  [self.delegate dismissedModal];
}

- (void)setGame:(SBGame *)game {
  [super setGame:game];

  self.currentTeamSchedule = self.game.awayTeam;

  [self setHeaderInfo];
}

- (void)setHeaderInfo {
  SBTeam *homeTeam = self.game.homeTeam;
  [self.homeTeamLogo setImageWithURL:[homeTeam imageURL:homeTeam.logoUrl withSize:@"120x120"]];
  self.homeTeamRecord.text = homeTeam.record;
  self.homeTeamName.text = homeTeam.name;

  SBTeam *awayTeam = self.game.awayTeam;
  [self.awayTeamLogo setImageWithURL:[awayTeam imageURL:awayTeam.logoUrl withSize:@"120x120"]];
  self.awayTeamRecord.text = awayTeam.record;
  self.awayTeamName.text = awayTeam.name;
}

- (void)changedTeam:(SBTeam *)updatedTeam {
  self.currentTeamSchedule = updatedTeam;

  [self.tableView reloadData];
}

#pragma mark - Table View

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
  return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
  if (!self.shouldRenderTable) {
    return 0;
  }

  if (section == 0) {
    return 2;
  }
  else {
    return 1;
  }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  if (indexPath.section == 0) {
    if (indexPath.row == kScoreRecapViewLocation) {
      SBContentTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kScoreContentCell forIndexPath:indexPath];
      cell.preview = self.game.preview;

      return cell;
    }
    else if (indexPath.row == kScoreDataViewLocation) {
      SBScoreDataTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kScoreDataCell forIndexPath:indexPath];
      cell.game = self.game;

      return cell;
    }
  }
  else if (indexPath.section == 1) {
    if (indexPath.row == kScheduleCellLocation) {
      SBScheduleTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kScheduleCell forIndexPath:indexPath];
      cell.game = self.game;
      cell.currentTeam = self.currentTeamSchedule;

      return cell;
    }
  }

  return nil;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
  if (!self.shouldRenderTable) {
    return nil;
  }

  if (section == 1 && [self.game.preview scheduleForTeam:self.currentTeamSchedule]) {
    SBScheduleSegmentedControlTableViewCell *cell = [tableView dequeueReusableHeaderFooterViewWithIdentifier:kSegmentedScheduleHeaderCell];
    cell.delegate = self;
    cell.selectedTeam = self.currentTeamSchedule;
    cell.game = self.game;

    return cell;
  }

  return nil;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
  if (indexPath.section == 0 ) {
    if (indexPath.row == kScoreRecapViewLocation) {
      [self openURL:self.game.preview.url];
    }
  }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
  if (!self.shouldRenderTable) {
    return 0;
  }

  if (section == 1 && [self.game.preview scheduleForTeam:self.currentTeamSchedule]) {
    return [SBScheduleSegmentedControlTableViewCell measureCellSizeWithResource:self.game andWidth:self.view.bounds.size.width].height;
  }

  return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
  CGFloat width = self.view.bounds.size.width;

  if (indexPath.section == 0) {
    if (indexPath.row == kScoreRecapViewLocation) {
      return [SBContentTableViewCell measureCellSizeWithResource:self.game andWidth:width].height;
    }
    else if (indexPath.row == kScoreDataViewLocation) {
      return [SBScoreDataTableViewCell measureCellSizeWithResource:self.game andWidth:width].height;
    }
  }
  else if (indexPath.section == 1) {
    if (indexPath.row == kScheduleCellLocation) {
      return [SBScheduleTableViewCell measureCellSizeWithResource:[self.game.preview scheduleForTeam:self.currentTeamSchedule] andWidth:width].height;
    }
  }

  return 0;
}

#pragma mark - Hack to enable heawder to have see through background

// http://stackoverflow.com/questions/12127138/how-to-mask-uitableviewcells-underneath-a-uitableview-transparent-header
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
  for (UITableViewCell *cell in self.tableView.visibleCells) {
    UIView *headerView = [self.tableView headerViewForSection:1];
    if ((int)headerView.frame.origin.y == (int)self.tableView.contentOffset.y) {
      CGFloat hiddenFrameHeight = scrollView.contentOffset.y + headerView.frame.size.height - cell.frame.origin.y;
      if (hiddenFrameHeight >= 0 || hiddenFrameHeight <= cell.frame.size.height) {
          [self maskCell:cell fromTopWithMargin:hiddenFrameHeight];
      }
    }
    else {
      cell.layer.mask = nil;
      cell.layer.masksToBounds = NO;
    }
  }
}

- (void)maskCell:(UITableViewCell *)cell fromTopWithMargin:(CGFloat)margin {
  cell.layer.mask = [self visibilityMaskForCell:cell withLocation:margin/cell.frame.size.height];
  cell.layer.masksToBounds = YES;
}

- (CAGradientLayer *)visibilityMaskForCell:(UITableViewCell *)cell withLocation:(CGFloat)location {
  CAGradientLayer *mask = [CAGradientLayer layer];
  mask.frame = cell.bounds;
  mask.colors = @[(id)[[UIColor colorWithWhite:1 alpha:0] CGColor], (id)[[UIColor colorWithWhite:1 alpha:1] CGColor]];
  mask.locations = @[@(location), @(location)];
  return mask;
}

@end