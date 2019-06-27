//
//  GHDatabaseBackup.h
//  Handicap
//
//  Created by Bryan Dunbar on 4/27/15.
//  Copyright (c) 2015 bdun. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SSZipArchive.h"
#import "SSManagedObject.h"

@interface GHDatabaseBackup : NSObject

@property (nonatomic,strong) NSString *deviceId;
@property (nonatomic,strong) NSString *dbPath;

-(instancetype)initWithDeviceId:(NSString*)deviceId andDbPath:(NSString*)dbPath;

-(void)backupDatabaseWithCompletion:(void (^)(void))block;
-(void)restoreDatabaseWithCompletion:(void(^)(void))block;

@end
