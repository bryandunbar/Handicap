//
//  GHAppDelegate.m
//  Golf Handicapper
//
//  Created by Bryan Dunbar on 6/15/13.
//  Copyright (c) 2013 iPwn Technologies LLC. All rights reserved.
//

#import "GHAppDelegate.h"
#import "GHPlayer.h"
#import "MBProgressHUD.h"
#import "SSKeychain.h"

@interface GHAppDelegate ()  {
    BOOL justRestored;
}

@end



@implementation GHAppDelegate


+ (NSString *)GetDeviceID {
    NSString *udidString = [SSKeychain passwordForService:@"com.ipwntech.Handicap" account:@"user"];
    if(!udidString){
        CFUUIDRef cfuuid = CFUUIDCreate(kCFAllocatorDefault);
        udidString = (NSString*)CFBridgingRelease(CFUUIDCreateString(kCFAllocatorDefault, cfuuid));
        CFRelease(cfuuid);
        [SSKeychain setPassword:udidString forService:@"com.ipwntech.Handicap" account:@"user"];
    }
    return udidString;
}

-(GHDatabaseBackup*)dbBackup {
    if (!_dbBackup) {
        _dbBackup = [[GHDatabaseBackup alloc] initWithDeviceId:[GHAppDelegate GetDeviceID] andDbPath:[SSManagedObject persistentStoreURL].path
                     ];
    }
    return _dbBackup;
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // Override point for customization after application launch.
    NSSetUncaughtExceptionHandler(&uncaughtExceptionHandler);
    //[SSKeychain deletePasswordForService:@"com.ipwntech.Handicap" account:@"user"];

    
    // Determine if the Database exists
    NSString *dbPath = [SSManagedObject persistentStoreURL].path;
    BOOL dbExists = [[NSFileManager defaultManager] fileExistsAtPath:dbPath];
    if (!dbExists) {
        
        //[MBProgressHUD showHUDAddedTo:self.window.rootViewController.view animated:YES];
        //justRestored = YES;
        //[self.dbBackup restoreDatabaseWithCompletion:^{
        //    [MBProgressHUD hideHUDForView:self.window.rootViewController.view animated:YES];
        //}];
    }
    
    
    return YES;
}

-(void)writeDBBackup {
    
    //[self.dbBackup backupDatabaseWithCompletion:^{
        
    //}];
    
}
- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    //[self writeDBBackup];
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    //if (!justRestored) {
    //    [self writeDBBackup];
    //}
    
    //justRestored = NO;
}
-(void)applicationWillTerminate:(UIApplication *)application {
}

void uncaughtExceptionHandler(NSException *exception) {
    NSLog(@"CRASH: %@", exception);
    NSLog(@"Stack Trace: %@", [exception callStackSymbols]);
    // Internal error reporting
}


@end
