//
//  GHPrintFormmater.h
//  Golf Handicapper
//
//  Created by Bryan Dunbar on 6/18/13.
//  Copyright (c) 2013 iPwn Technologies LLC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GHCourse.h"
#import "GHLeague.h"

@interface GHPrintFormmater : NSObject

-(NSString*)htmlRankingForData:(NSArray*)array league:(GHLeague*)league andCourse:(GHCourse*)course;
-(NSString*)htmlCardsForData:(NSArray *)array league:(GHLeague*)league andCourse:(GHCourse*)course showThisLeageOnly:(BOOL)showThisLeagueOnly showThisCourseOnly:(BOOL)showThisCourseOnly;
-(NSString*)htmlCardForPlayer:(NSDictionary *)printDict league:(GHLeague*)league andCourse:(GHCourse*)course showThisLeageOnly:(BOOL)showThisLeagueOnly showThisCourseOnly:(BOOL)showThisCourseOnly;
@end
