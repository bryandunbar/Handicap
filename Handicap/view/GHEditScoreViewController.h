//
//  GHEditScoreViewController.h
//  Golf Handicapper
//
//  Created by Bryan Dunbar on 6/18/13.
//  Copyright (c) 2013 iPwn Technologies LLC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GHScore.h"
#import "UQFormTableViewController.h"
@interface GHEditScoreViewController : UQFormTableViewController
@property (nonatomic,strong) GHScore *score;
@end
