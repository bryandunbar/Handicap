//
//  GHPrintFormmater.m
//  Golf Handicapper
//
//  Created by Bryan Dunbar on 6/18/13.
//  Copyright (c) 2013 iPwn Technologies LLC. All rights reserved.
//

#import "GHPrintFormmater.h"
#import "GHPlayer.h"
#import "GHScore.h"


@interface GHPrintFormmater () {
}
@property (nonatomic,readonly) NSDateFormatter *formatter;
@end

@implementation GHPrintFormmater
@synthesize formatter=_formatter;

-(NSDateFormatter*)formatter {
    if (!_formatter) {
        _formatter = [[NSDateFormatter alloc] init];
        [_formatter setDateStyle:NSDateFormatterShortStyle];
    }
    return _formatter;
}
-(NSString*)htmlRankingForData:(NSArray *)data league:(GHLeague*)league andCourses:(NSArray*)courses {

    NSMutableString *html = [NSMutableString stringWithString:@"<html><body>"];
    
    if (courses[0]) {
        [html appendFormat:@"<div style='font-size:20; font-weight:bold'>Trend Listing for %@</br>%@</div>", league.name, [courses[0] name]];
    } else {
        [html appendFormat:@"<div style='font-size:20; font-weight:bold'>Index Listing for %@</div>", league.name];
    }
    
    [html appendString:@"<hr/>"];
    [html appendString:@"<table style='width:100%'>"];

    int totalCols = 1; //Player Name
    int playerNameColSpan = 0;
    if (courses.count <=1) {
        totalCols = totalCols + 1;
        playerNameColSpan = 1;
    } else {
        totalCols = totalCols + courses.count;
        playerNameColSpan = totalCols - courses.count;
    }
    
    // TEES Headers
    if (courses) {
        [html appendString:@"<tr>"];
        [html appendFormat:@"<td colspan='%d'>&nbsp;</td>", playerNameColSpan];
        for (GHCourse *course in courses) {
            [html appendFormat:@"<td style='text-align:center;width:100px'><h3>%@</h3></td>", course.tees];
        }
        [html appendString:@"</tr>"];
    }
    
    for (NSDictionary *dict in data) {
        GHPlayer *player = dict[@"player"];

        [html appendString:@"<tr>"];
        [html appendFormat:@"<td>%@</td>", [player description]];

        if (courses) {
            for (GHCourse *course in courses) {
                [html appendFormat:@"<td style='text-align:center;width:100px'><h3>%@</h3></td>", [self trendValueFromDict:dict forCourse:course]];
            }
        } else {
            // Show Index
            [html appendFormat:@"<td style='text-align:center;width:100px'><h3>%@</h3></td>", [self indexValueFromDict:dict]];
        }
        
        [html appendString:@"</tr>"];
        
    }
        
    [html appendString:@"</table>"];
    [html appendString:@"</body></html>"];
    
    return [NSString stringWithString:html];

    
}

#define CARDS_PER_ROW 2
#define ROWS_PER_PAGE 4
#define SCORES_PER_ROW 5

-(NSString*)htmlCardsForData:(NSArray *)array league:(GHLeague *)league andCourses:(NSArray *)courses showThisLeageOnly:(BOOL)showThisLeagueOnly showThisCourseOnly:(BOOL)showThisCourseOnly {
    NSMutableString *html = [NSMutableString stringWithString:@"<html><body>"];

    
    [html appendString:@"<table style='width:700px'>"];
    [html appendString:@"<tr>"];
    
    for (int i = 0; i < array.count; i++) {
        
        if (i > 0 && i % CARDS_PER_ROW == 0) { // 2up
            [html appendString:@"</tr>"];
            
            if (i > 0 && i % (CARDS_PER_ROW * ROWS_PER_PAGE) == 0) {
                [html appendString:@"<tr height='60px'><td colspan='2'></td></tr>"];
            }
             [html appendString:@"<tr>"];
        }
        
        [html appendString:@"<td style='width:50%'>"];
        NSDictionary *dict = array[i];
        [html appendString:[self htmlCardForPlayer:dict league:league andCourses:courses showThisLeageOnly:showThisCourseOnly showThisCourseOnly:showThisCourseOnly]];
        [html appendString:@"</td>"];
    }
    
    [html appendString:@"</tr>"];
    [html appendString:@"</table>"];
    [html appendString:@"</body></html>"];
    return [NSString stringWithString:html];
}


-(NSString*)htmlCardForPlayer:(NSDictionary *)printDict league:(GHLeague *)league andCourses:(NSArray *)courses showThisLeageOnly:(BOOL)showThisLeagueOnly showThisCourseOnly:(BOOL)showThisCourseOnly {
    
    GHPlayer *player = printDict[@"player"];
    NSArray *usedScores = printDict[@"usedScores"];
    NSString *handicapIndex = [self indexValueFromDict:printDict];
    NSDate *date = [NSDate date];
    
    
    // Build the predicate
    NSPredicate *predicate = nil;
    if (showThisLeagueOnly) {
        predicate = [NSPredicate predicateWithFormat:@"league == %@", league];
    }
    
    if (showThisCourseOnly) {
        NSPredicate *subPredicate = [NSPredicate predicateWithFormat:@"course == %@", courses[0]];
        if (!predicate) {
            predicate = subPredicate;
        } else {
            predicate = [NSCompoundPredicate andPredicateWithSubpredicates:@[predicate, subPredicate]];
        }
    }
    
    NSSet *scoreSet = predicate != nil ?
    [player.scores filteredSetUsingPredicate:predicate] : player.scores;
    
    
    NSArray *scores = [[scoreSet allObjects] sortedArrayUsingDescriptors:[GHScore defaultSortDescriptors]];

    
    NSMutableString *html = [NSMutableString stringWithString:@"<table style='border:1px solid black; width='100%'>"];
    [html appendString:@"<tr>"];
    //[html appendString:@"<td colspan='2'><strong>Name</strong</td>"];
    [html appendFormat:@"<td colspan='4'><strong>%@</strong></td>", [player description]];
    [html appendFormat:@"<td coslpan='1' style='text-align:right'><strong>%@</strong></td>", handicapIndex];
    [html appendString:@"</tr>"];

    //[html appendString:@"<td colspan='2'><strong>Course</strong</td>"];
    if (courses) {
        for (GHCourse *course in courses) {
            [html appendString:@"<tr>"];
            [html appendFormat:@"<td colspan='4'><strong>%@</strong></td>", [course description]];
            NSString *trend = [self trendValueFromDict:printDict forCourse:course];
            [html appendFormat:@"<td coslpan='1' style='text-align:right'><strong>%@</strong></td>", trend];
            [html appendString:@"<tr>"];
        }
    } else {
        [html appendString:@"<tr><td colspan='5'>&nbsp;</td></td>"];
    }
    [html appendString:@"</tr>"];

    [html appendString:@"<tr>"];
    [html appendString:@"<td colspan='2'><strong>Effective Date</strong</td>"];
    [html appendFormat:@"<td colspan='2'>%@</td>", [self.formatter stringFromDate:date]];
    [html appendString:@"<td coslpan='1'>&nbsp;</td>"];
    [html appendString:@"</tr>"];

    [html appendString:@"<tr>"];
    [html appendString:@"<td colspan='2'><strong>Scores Posted</strong</td>"];
    [html appendFormat:@"<td colspan='2'>%d</td>", MIN(20, scores.count)];
    [html appendString:@"<td coslpan='1'>&nbsp;</td>"];
    [html appendString:@"</tr>"];

    [html appendString:@"<tr><td style='background-color:black; color:white; text-align:center' colspan='5'>SCORES - MOST RECENT FIRST *IF USED</td></tr>"];

    [html appendString:@"<tr style='text-align:center'>"];
    for (int i = 0; i < 20; i++) {
    
        if (i > 0 && i % SCORES_PER_ROW == 0) { // 5up
            [html appendString:@"</tr><tr style='text-align:center'>"];
        }
        
        GHScore *score = i < scores.count ? scores[i] : nil;
        [html appendString:@"<td style='width: 20%; text-align:center'>"];
        
        if (score == nil) {
            [html appendString:@"&nbsp;"];
        } else {
            [html appendFormat:@"%d%@", [score.value intValue], ([usedScores containsObject:score] ? @"*" : @"")];
        }
        
        [html appendString:@"</td>"];
        
    }
    
    [html appendString:@"</tr>"];
    [html appendString:@"</table>"];
    return [NSString stringWithString:html];
    
    
}

-(NSString*)trendValueFromDict:(NSDictionary*)printDict forCourse:(GHCourse *)course {
    NSUInteger trend = [printDict[@"trend"][[course description]] unsignedIntegerValue];
    if (trend == NSNotFound)
        return @"NH";
    else
        return [NSString stringWithFormat:@"%lu", (unsigned long)trend];
}

-(NSString*)indexValueFromDict:(NSDictionary*)printDict {
    
    double index = [printDict[@"index"] doubleValue];
    if (index == NSNotFound)
        return @"NH";
    else
        return [NSString stringWithFormat:@"%2.1f", index];

}



@end
