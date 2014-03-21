//
//  GHAddOrEditPlayerViewController.h
//  Golf Handicapper
//
//  Created by Bryan Dunbar on 6/15/13.
//  Copyright (c) 2013 iPwn Technologies LLC. All rights reserved.
//

#import "UQFormTableViewController.h"
#import "GHPlayer.h"

@interface GHAddOrEditPlayerViewController : UQFormTableViewController

@property (nonatomic,strong) GHPlayer *player;
@end
