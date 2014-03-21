//
//  GHPlayer.h
//  Golf Handicapper
//
//  Created by Bryan Dunbar on 6/15/13.
//  Copyright (c) 2013 iPwn Technologies LLC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "SSManagedObject.h"
#import "GHHandicapCalculator.h"

@class GHLeague;
@class GHScore;

@interface GHPlayer : SSManagedObject

@property (nonatomic, retain) NSString * firstName;
@property (nonatomic, retain) NSNumber * handicapIndex;
@property (nonatomic, retain) NSString * lastName;
@property (nonatomic, retain) NSSet *leagues;
@property (nonatomic, retain) NSSet *scores;

/** Transient **/
@property (nonatomic, retain) NSNumber * score;

@property (nonatomic,readonly) GHHandicapCalculator *calculator;

@end

@interface GHPlayer (CoreDataGeneratedAccessors)

- (void)addLeaguesObject:(GHLeague *)value;
- (void)removeLeaguesObject:(GHLeague *)value;
- (void)addLeagues:(NSSet *)values;
- (void)removeLeagues:(NSSet *)values;

- (void)addScoresObject:(GHScore *)value;
- (void)removeScoresObject:(GHScore *)value;
- (void)addScores:(NSSet *)values;
- (void)removeScores:(NSSet *)values;

-(double)calculateIndex;

@end
