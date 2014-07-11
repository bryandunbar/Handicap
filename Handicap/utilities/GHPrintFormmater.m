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
-(NSString*)htmlRankingForData:(NSArray *)data league:(GHLeague*)league andCourse:(GHCourse *)course {

    NSMutableString *html = [NSMutableString stringWithString:@"<html><body>"];
    
    if (course) {
        [html appendFormat:@"<div style='font-size:20; font-weight:bold'>Trend Listing for %@</br>%@</div>", league.name, [course description]];
    } else {
        [html appendFormat:@"<div style='font-size:20; font-weight:bold'>Index Listing for %@</div>", league.name];
    }
    
    [html appendString:@"<hr/>"];
    [html appendString:@"<table style='width:100%'>"];
    
    for (NSDictionary *dict in data) {
        GHPlayer *player = dict[@"player"];

        NSString *handicap = nil;
        if (course) { // Showing trends
            handicap = [self trendValueFromDict:dict];
        } else {
            handicap = [self indexValueFromDict:dict];
        }
        
        [html appendFormat:@"<tr><td><h3>%@</h3></td><td style='text-align:right'><h3>%@</h3></td></tr>", [player description], handicap];
    }
        
    [html appendString:@"</table>"];
    [html appendString:@"</body></html>"];
    
    return [NSString stringWithString:html];

    
}

#define CARDS_PER_ROW 2
#define ROWS_PER_PAGE 4
#define SCORES_PER_ROW 5

-(NSString*)htmlCardsForData:(NSArray *)array league:(GHLeague *)league andCourse:(GHCourse *)course {
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
        [html appendString:[self htmlCardForPlayer:dict league:league andCourse:course]];
        [html appendString:@"</td>"];
    }
    
    [html appendString:@"</tr>"];
    [html appendString:@"</table>"];
    [html appendString:@"</body></html>"];
    return [NSString stringWithString:html];
}


-(NSString*)htmlCardForPlayer:(NSDictionary *)printDict league:(GHLeague *)league andCourse:(GHCourse *)course {
    
    GHPlayer *player = printDict[@"player"];
    NSArray *usedScores = printDict[@"usedScores"];
    NSString *handicapIndex = [self indexValueFromDict:printDict];
    NSString *trend = [self trendValueFromDict:printDict];
    NSDate *date = [NSDate date];
    NSArray *scores = [player.scores sortedArrayUsingDescriptors:[GHScore defaultSortDescriptors]];

    
    NSMutableString *html = [NSMutableString stringWithString:@"<table style='border:1px solid black; width='100%'>"];
    [html appendString:@"<tr>"];
    //[html appendString:@"<td colspan='2'><strong>Name</strong</td>"];
    [html appendFormat:@"<td colspan='4'><strong>%@</strong></td>", [player description]];
    [html appendFormat:@"<td coslpan='1' style='text-align:right'><strong>%@</strong></td>", handicapIndex];
    [html appendString:@"</tr>"];

    [html appendString:@"<tr>"];
    //[html appendString:@"<td colspan='2'><strong>Course</strong</td>"];
    [html appendFormat:@"<td colspan='4'><strong>%@</strong></td>", [course description]];
    [html appendFormat:@"<td coslpan='1' style='text-align:right'><strong>%@</strong></td>", trend];
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

-(NSString*)trendValueFromDict:(NSDictionary*)printDict {
    int trend = [printDict[@"trend"] intValue];
    if (trend == NSNotFound)
        return @"NH";
    else
        return [NSString stringWithFormat:@"%d", trend];
}

-(NSString*)indexValueFromDict:(NSDictionary*)printDict {
    
    double index = [printDict[@"index"] doubleValue];
    if (index == NSNotFound)
        return @"NH";
    else
        return [NSString stringWithFormat:@"%2.1f", index];

}



@end
