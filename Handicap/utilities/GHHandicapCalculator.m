//
//  GHHandicapCalculator.m
//  Golf Handicapper
//
//  Created by Bryan Dunbar on 6/17/13.
//  Copyright (c) 2013 iPwn Technologies LLC. All rights reserved.
//

#import "GHHandicapCalculator.h"
#import "GHPlayer.h"
#import "GHScore.h"

@interface GHHandicapCalculator()

-(NSArray*)orderedDifferentials:(NSArray*)scores;
@end

@implementation GHHandicapCalculator

-(double)handicapIndexForScores:(NSArray *)scores usedScores:(NSArray**)usedScoreArrayReference {

    // Compute the differentials we'll use to calculate the index for the set of scores given
    NSArray *differentials = [self orderedDifferentials:scores];
    
    // We'll only use a sub-range of diffs based on how many were given
    NSRange diffRange;
    diffRange.location = 0; // Always start at the lowest diff
    
    int numDiffs = differentials.count;
    if (numDiffs < 5) {
        return NSNotFound; // Can't even compute if we don't have 5 scores
    } else if (numDiffs <= 6) {
        diffRange.length = 1;
    } else if (numDiffs <= 8) {
        diffRange.length = 2;
    } else if (numDiffs <= 10) {
        diffRange.length = 3;
    } else if (numDiffs <= 12) {
        diffRange.length = 4;
    } else if (numDiffs <= 14) {
        diffRange.length = 5;
    } else if (numDiffs <= 16) {
        diffRange.length = 6;
    } else {
        diffRange.length = numDiffs - 10;
    }
    
    // Slice the array
    NSArray *slicedDiffs = [differentials subarrayWithRange:diffRange];

    // Keep track of what scores are used in the calculation
    NSMutableArray *usedScoreCollector = [NSMutableArray arrayWithCapacity:slicedDiffs.count];
    
    // Find the average
    __block double sum = 0.0;
    [slicedDiffs enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        NSDictionary *diffDict = (NSDictionary*)obj;
        
        // Add the differential
        NSNumber *diff = (NSNumber*)diffDict[@"diff"];
        sum += [diff doubleValue];
        
        // This score was used
        [usedScoreCollector addObject:diffDict[@"score"]];
    }];
    
    if (usedScoreArrayReference != NULL) {
        *usedScoreArrayReference = [NSArray arrayWithArray:usedScoreCollector];
    }
    
    // Calculate the index
    double avg = sum / slicedDiffs.count;
    double index = avg * 0.96;
    
    // truncate to 1 decimal
    double indexTruncated = ( (int)(index*10))/10.0;
    return indexTruncated;
    
}

-(NSArray*)orderedDifferentials:(NSArray *)scores {
    
    // First sort the scores by date descending
    NSArray *sortedScores = [scores sortedArrayUsingDescriptors:[GHScore defaultSortDescriptors]];
    
    // Now we only need a max of 20
    NSRange range = NSMakeRange(0, 20);
    NSArray *finalScores = (scores.count > 20) ? [sortedScores subarrayWithRange:range] : sortedScores;
    
    // Now create the differentials
    NSMutableArray *array = [NSMutableArray arrayWithCapacity:finalScores.count];
    for (GHScore *score in finalScores) {
        [array addObject:
         @{
            @"score":score,
            @"diff":@(score.differential)
         }];
    }
    
    // Sort ascending
    NSArray *sortedDiffs = [array sortedArrayUsingDescriptors:@[[NSSortDescriptor sortDescriptorWithKey:@"diff" ascending:YES]]];
    //NSArray *sortedDiffs = [array sortedArrayUsingSelector:@selector(compare:)];
    return sortedDiffs;
}


-(int)courseHandicapForHandicap:(double)handicapIndex forCourse:(GHCourse *)course {
    if (handicapIndex == NSNotFound || course == nil) return NSNotFound;
    return lroundf(handicapIndex * [course.slope intValue] / 113);
}

@end
