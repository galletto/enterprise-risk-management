//
//  AGCCoreDataHelper.h
//  Risk Management
//
//  Created by Alessandro on 05/04/14.
//  Copyright (c) 2014 Alessandro Galletto. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@interface AGCCoreDataHelper :NSObject <UIAlertViewDelegate, NSXMLParserDelegate>

@property (nonatomic, retain) UIAlertView *importAlertView;
@property (nonatomic, strong) NSXMLParser *parser;

@property (nonatomic, readonly) NSManagedObjectContext *context;
@property (nonatomic, readonly) NSManagedObjectContext *importContext;
@property (nonatomic, readonly) NSManagedObjectContext *parentContext;
@property (nonatomic, readonly) NSManagedObjectModel *model;
@property (nonatomic, readonly) NSPersistentStoreCoordinator *coordinator;
@property (nonatomic, readonly) NSPersistentStore *store;
@property (nonatomic, readonly) NSPersistentStore *iCloudStore;

@property (nonatomic, readonly) NSManagedObjectContext *sourceContext;
@property (nonatomic, readonly) NSPersistentStoreCoordinator *sourceCoordinator;
@property (nonatomic, readonly) NSPersistentStore *sourceStore;

- (void)setupCoreData;
- (void)saveContext;
- (BOOL)iCloudAccountIsSignedIn;

@end