//
//  AGCAppDelegate.m
//  Enterprise Risk Management
//
//  Created by Alessandro on 16/03/14.
//  Copyright (c) 2014 Alessandro Galletto. All rights reserved.
//

#pragma mark - Core data imports
#import "AGCAppDelegate.h"
#import "Data_classification.h"
#import "Threat.h"
#import "Integrity_req.h"
#import "Site.h"
#import "Risk_group.h"
#import "Business_process.h"
#import "Impact.h"
#import "Availability_req.h"
#import "Asset_care_criteria.h"
#import "Likelihood.h"
#import "Owner.h"
#import "Risk.h"
#import "Risk_matrix.h"
#import "Risk_level.h"
#import "Asset.h"
#import "unistd.h"

#pragma mark - TableViewControllers imports

@implementation AGCAppDelegate

#define debug 1

#pragma mark - Application Delegates

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // Override point for customization after application launch.
    sleep(3);
    [[self base_de_datos] iCloudAccountIsSignedIn];
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    [[self base_de_datos] saveContext];
    
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    
    if (debug==1) {
        NSLog(@"Running %@ '%@'", self.class, NSStringFromSelector(_cmd));
        }
    
    [self base_de_datos];
    [self demo];
    
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    [[self base_de_datos] saveContext];
}

#pragma mark - Button IBActions

#pragma mark - Table View Data source delegates

#pragma mark - Class Methods

- (AGCCoreDataHelper *) base_de_datos {
    if (debug==1) {
        NSLog(@"Running %@ '%@'", self.class, NSStringFromSelector(_cmd));
    }
    
    if (!_coreDataHelper) {
        static dispatch_once_t predicate;
        dispatch_once(&predicate, ^{_coreDataHelper = [AGCCoreDataHelper new];} );
        [_coreDataHelper setupCoreData];
    }
    
    return _coreDataHelper;
}

- (void) demo {
    
}


@end
