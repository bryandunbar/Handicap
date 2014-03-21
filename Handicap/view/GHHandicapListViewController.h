//
//  GHHandicapListViewController.h
//  Golf Handicapper
//
//  Created by Bryan Dunbar on 6/17/13.
//  Copyright (c) 2013 iPwn Technologies LLC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GHCourse.h"
#import "GHPlayer.h"
#import "GHLeague.h"

typedef enum GHHandicapListViewPrintOptions {
    GHHandicapListViewPrintList = 0,
    GHHandicapListViewPrintCards = 1
} GHHandicapListViewPrintOptions;

@interface GHHandicapListViewController : UITableViewController

@property (nonatomic,strong) GHCourse *course; /** If nil, show indices **/
@property (nonatomic,strong) GHLeague *league;
@property (nonatomic) BOOL useScoresFromSelectedLeagueOnly;

@end
