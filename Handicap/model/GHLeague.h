//
//  GHLeague.h
//  Golf Handicapper
//
//  Created by Bryan Dunbar on 6/15/13.
//  Copyright (c) 2013 iPwn Technologies LLC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "SSManagedObject.h"

@class GHPlayer;

@interface GHLeague : SSManagedObject

@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSSet *players;
@end

@interface GHLeague (CoreDataGeneratedAccessors)

- (void)addPlayersObject:(GHPlayer *)value;
- (void)removePlayersObject:(GHPlayer *)value;
- (void)addPlayers:(NSSet *)values;
- (void)removePlayers:(NSSet *)values;

@end
