//
//  CoreDataHelper.h
//  v2.0
//
//  Created by Tim Roadley on 09/09/13.
//  Copyright (c) 2013 Tim Roadley. All rights reserved.
//
//  This class is free to use in production applications for owners of "Learning Core Data for iOS" by Tim Roadley
//

/*
SETUP:
 
    1. Gain reference to CoreDataHelper from any class by importing CoreDataHelper.h and using the following code:
 
        [CoreDataHelper sharedHelper];

    2. Don't forget to add a Core Data > Data Model and design it as you see fit.

    3. If you're using deep copy migration, update the selectedUniqueAttributes and mergeNoniCloudDataWithiCloud method as per Chapter 8 and Chapter 9
 
 
EXAMPLE USE:
 
    ** Access the main thread context:
 
        [[CoreDataHelper sharedHelper] context];
 
    ** Save the main thread context through the context hierarchy
 
        [[CoreDataHelper sharedHelper] backgroundSaveContext];
 
    ** Access the import context for importing data
 
        [[CoreDataHelper sharedHelper] importContext];
 
    ** Save any context through the context hierarchy
 
        [CoreDataHelper saveContextHierarchy:[[CoreDataHelper sharedHelper] importContext]];
 
    ** Perform a block. Substitute a relevant context and performBlockAndWait as necessary
 
        [[[CoreDataHelper sharedHelper] context] performBlock:^{
 
            // Do stuff
        }];
 
 
 FOR MORE INFORMATION:

    Please read "Learning Core Data for iOS" by Tim Roadley.
 
 */


#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
//#import "MigrationVC.h" // See Chapter 3 to enable manual migration

@interface CoreDataHelper : NSObject <UIAlertViewDelegate>

@property (nonatomic, readonly) NSManagedObjectContext       *parentContext;
@property (nonatomic, readonly) NSManagedObjectContext       *context;
@property (nonatomic, readonly) NSManagedObjectContext       *importContext;
@property (nonatomic, readonly) NSManagedObjectModel         *model;
@property (nonatomic, readonly) NSPersistentStoreCoordinator *coordinator;
@property (nonatomic, readonly) NSPersistentStore            *store;

@property (nonatomic, readonly) NSManagedObjectContext       *sourceContext;
@property (nonatomic, readonly) NSPersistentStoreCoordinator *sourceCoordinator;
@property (nonatomic, readonly) NSPersistentStore            *sourceStore;

@property (nonatomic, readonly) NSManagedObjectContext       *seedContext;
@property (nonatomic, readonly) NSPersistentStoreCoordinator *seedCoordinator;
@property (nonatomic, readonly) NSPersistentStore            *seedStore;
@property (nonatomic, retain)   UIAlertView                  *seedAlertView;
@property (nonatomic)           BOOL                          seedInProgress;

@property (nonatomic, readonly) NSPersistentStore *iCloudStore;
//@property (nonatomic, retain) MigrationVC *migrationVC; // See Chapter 3 to enable manual migration
@property (nonatomic, retain) UIAlertView *importAlertView;
@property (nonatomic, strong) NSTimer *importTimer;

+ (CoreDataHelper*)sharedHelper;
+ (void)saveContextHierarchy:(NSManagedObjectContext*)moc;
+ (void)resetContextHierarchy:(NSManagedObjectContext*)moc;
- (void)setupCoreData;
- (void)saveContext;
- (void)backgroundSaveContext;
- (BOOL)reloadStore;
- (NSURL *)applicationStoresDirectory;
- (BOOL)iCloudAccountIsSignedIn;
- (void)ensureAppropriateStoreIsLoaded;
- (BOOL)iCloudEnabledByUser;

@end
