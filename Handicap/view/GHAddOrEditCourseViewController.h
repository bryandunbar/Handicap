//
//  GHAddOrEditCourseViewController.h
//  Golf Handicapper
//
//  Created by Bryan Dunbar on 6/15/13.
//  Copyright (c) 2013 iPwn Technologies LLC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UQFormTableViewController.h"
#import "GHCourse.h"

@interface GHAddOrEditCourseViewController : UQFormTableViewController <UITextFieldDelegate>

@property (nonatomic,strong) GHCourse *course;


@end
