//
//  GHPlayer.m
//  Golf Handicapper
//
//  Created by Bryan Dunbar on 6/15/13.
//  Copyright (c) 2013 iPwn Technologies LLC. All rights reserved.
//

#import "GHPlayer.h"
#import "GHLeague.h"


@implementation GHPlayer

@dynamic firstName;
@dynamic handicapIndex;
@dynamic lastName;
@dynamic leagues;
@dynamic scores;

/** Transient Properties **/
@dynamic score;

@synthesize calculator=_calculator;

-(GHHandicapCalculator*)calculator {
    if (!_calculator) {
        _calculator = [[GHHandicapCalculator alloc] init];
    }
    return _calculator;
}

+ (NSString *)entityName {
    return @"Player";
}
+ (NSArray *)defaultSortDescriptors {
    return @[[NSSortDescriptor sortDescriptorWithKey:@"lastName" ascending:YES], [NSSortDescriptor sortDescriptorWithKey:@"firstName" ascending:YES]];
}

-(NSString*)description {
    return [NSString stringWithFormat:@"%@, %@", self.lastName, self.firstName];
}

-(double)calculateIndex {
    NSArray *scores = [self.scores allObjects];
    double index = [self.calculator handicapIndexForScores:scores usedScores:NULL];
    self.handicapIndex = @(index);
    [self save];
    return index;
}

@end
