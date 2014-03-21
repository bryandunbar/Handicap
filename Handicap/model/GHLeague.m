//
//  GHLeague.m
//  Golf Handicapper
//
//  Created by Bryan Dunbar on 6/15/13.
//  Copyright (c) 2013 iPwn Technologies LLC. All rights reserved.
//

#import "GHLeague.h"
#import "GHPlayer.h"


@implementation GHLeague

@dynamic name;
@dynamic players;


+ (NSString *)entityName {
    return @"League";
}
+ (NSArray *)defaultSortDescriptors {
    return @[[NSSortDescriptor sortDescriptorWithKey:@"name" ascending:YES]];
}

@end
