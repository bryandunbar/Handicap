//
//  GHCourse.m
//  Golf Handicapper
//
//  Created by Bryan Dunbar on 6/15/13.
//  Copyright (c) 2013 iPwn Technologies LLC. All rights reserved.
//

#import "GHCourse.h"


@implementation GHCourse

@dynamic abbreviation;
@dynamic name;
@dynamic rating;
@dynamic slope;
@dynamic tees;


+(NSString *)entityName {
    	return @"Course";
}
+ (NSArray *)defaultSortDescriptors {
 return @[[NSSortDescriptor sortDescriptorWithKey:@"name" ascending:YES]];
}

-(NSString*)description {
    return [NSString stringWithFormat:@"%@ [%@]", self.name, self.tees];
}
@end
