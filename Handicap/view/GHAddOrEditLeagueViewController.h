//
//  GHAddOrEditLeagueViewController.h
//  Golf Handicapper
//
//  Created by Bryan Dunbar on 6/15/13.
//  Copyright (c) 2013 iPwn Technologies LLC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UQFormTableViewController.h"
#import "GHLeague.h"

@interface GHAddOrEditLeagueViewController : UQFormTableViewController <UITextFieldDelegate>

@property (nonatomic,strong) GHLeague *league;


@end
