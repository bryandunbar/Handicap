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

@property (nonatomic,strong) NSArray *courses; /** If nil, or empty, show indices **/
@property (nonatomic,strong) GHLeague *league;
@property (nonatomic,strong) NSString *tees; /** If nil, show all tees for the course */
@property (nonatomic) BOOL useScoresFromSelectedLeagueOnly;
@property (nonatomic) BOOL useScoresFromSelectedCourseOnly;
@end
