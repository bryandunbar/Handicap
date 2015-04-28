//
//  GHDatabaseBackup.m
//  Handicap
//
//  Created by Bryan Dunbar on 4/27/15.
//  Copyright (c) 2015 bdun. All rights reserved.
//

#import "GHDatabaseBackup.h"
#import "GHAppDelegate.h"
#import "SSKeychain.h"
#import "SSZipArchive.h"

@implementation GHDatabaseBackup


-(instancetype)initWithDeviceId:(NSString *)deviceId andDbPath:(NSString *)dbPath {
    self = [super init];
    if (self) {
        self.deviceId = deviceId;
        self.dbPath = dbPath;
    }
    return self;
}
-(void)backupDatabaseWithCompletion:(void (^)(void))block {
    PFQuery *query = [PFQuery queryWithClassName:@"Backup"];
    [query whereKey:@"device_id" equalTo:self.deviceId];
    [query findObjectsInBackgroundWithBlock:^(NSArray *arr, NSError *error) {
        PFObject *obj = nil;
        if (arr.count > 0) {
            obj = arr[0];
        } else {
            obj = [PFObject objectWithClassName:@"Backup"];
            obj[@"device_id"] = self.dbPath;
        }
        
        // File Paths
        NSString *sqlLitePath = self.dbPath;
        NSString *walPath = [NSString stringWithFormat:@"%@-wal", sqlLitePath];
        NSString *zippedPath = [NSString stringWithFormat:@"%@.zip", sqlLitePath];
        [SSZipArchive createZipFileAtPath:zippedPath withFilesAtPaths:@[sqlLitePath, walPath]];
        
        NSData *data = [NSData dataWithContentsOfFile:zippedPath];
        PFFile *file = [PFFile fileWithData:data];
        obj[@"db"] = file;
        obj[@"device_name"] = [UIDevice currentDevice].name;
        [obj saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
            block();
        }];
        
    }];

}

-(void)restoreDatabaseWithCompletion:(void (^)(void))block {
    
    // Grab the DB from Parse
    PFQuery *query = [PFQuery queryWithClassName:@"Backup"];
    [query whereKey:@"device_id" equalTo:self.deviceId];
    [query findObjectsInBackgroundWithBlock:^(NSArray *arr, NSError *error) {
        if (arr.count > 0) {
            PFFile *db = arr[0][@"db"];
            [db getDataInBackgroundWithBlock:^(NSData *data, NSError *error) {
                
                // Write the zip
                NSString *zippedDbPath = [NSString stringWithFormat:@"%@.zip", self.dbPath];
                [data writeToFile:zippedDbPath atomically:YES];
                
                // Now unzip
                NSString *dest = [self.dbPath stringByDeletingLastPathComponent];
                [SSZipArchive unzipFileAtPath:zippedDbPath toDestination:dest];
                
                block();
            }];
        }
    }];

}




@end
