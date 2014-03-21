//
//  GHScoreListViewController.h
//  Golf Handicapper
//
//  Created by Bryan Dunbar on 6/18/13.
//  Copyright (c) 2013 iPwn Technologies LLC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GHPlayer.h"

@interface GHScoreListViewController : UITableViewController

@property (nonatomic,strong) GHPlayer *player;
@end
