//
//  GHCourse.h
//  Golf Handicapper
//
//  Created by Bryan Dunbar on 6/15/13.
//  Copyright (c) 2013 iPwn Technologies LLC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "SSManagedObject.h"

@interface GHCourse : SSManagedObject

@property (nonatomic, retain) NSString * abbreviation;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSNumber * rating;
@property (nonatomic, retain) NSNumber * slope;
@property (nonatomic, retain) NSString * tees;

@end
