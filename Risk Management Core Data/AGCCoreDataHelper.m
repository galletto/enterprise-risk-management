//
//  AGCCoreDataHelper.m
//  Risk Management
//
//  Created by Alessandro on 05/04/14.
//  Copyright (c) 2014 Alessandro Galletto. All rights reserved.
//

#import "AGCCoreDataHelper.h"
#import "AGCCoreDataImporter.h"
#import <CoreData/CoreData.h>

#define debug 0

@implementation AGCCoreDataHelper

#pragma mark - FILES
NSString *storeFilename = @"Risk-Management.sqlite";
NSString *iCloudStoreFilename = @"iCloud.sqlite";

#pragma mark - PATHS
- (NSString *)applicationDocumentsDirectory {
    if (debug==1) {
        NSLog(@"Running %@ '%@'", self.class,NSStringFromSelector(_cmd));
    }
    return [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask,YES) lastObject];
}

- (NSURL *)applicationStoresDirectory {
    if (debug==1) {
        NSLog(@"Running %@ '%@'", self.class, NSStringFromSelector(_cmd));
    }

    NSURL *storesDirectory =
    [[NSURL fileURLWithPath:[self applicationDocumentsDirectory]] URLByAppendingPathComponent:@"Stores"];
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if (![fileManager fileExistsAtPath:[storesDirectory path]]) {
        NSError *error = nil;
        if ([fileManager createDirectoryAtURL:storesDirectory
                 withIntermediateDirectories:YES
                 attributes:nil
                 error:&error]) {
            if (debug==1) {
                NSLog(@"Successfully created Stores directory");}
            }
        else {NSLog(@"FAILED to create Stores directory: %@", error);}
        }
    return storesDirectory;
}

- (NSURL *)storeURL {
    if (debug==1) {
        NSLog(@"Running %@ '%@'", self.class, NSStringFromSelector(_cmd));
    }
    return [[self applicationStoresDirectory]
            URLByAppendingPathComponent:storeFilename];
}

- (NSURL *)iCloudStoreURL {
    if (debug==1) {
        NSLog(@"Running %@ '%@'", self.class, NSStringFromSelector(_cmd));
    }
    return [[self applicationStoresDirectory]
                URLByAppendingPathComponent:iCloudStoreFilename];
}

#pragma mark - SETUP
- (id)init {
    if (debug==1) {
        NSLog(@"Running %@ '%@'", self.class, NSStringFromSelector(_cmd));
    }
    self = [super init];
    if (!self) {return nil;}
    
    _model = [NSManagedObjectModel mergedModelFromBundles:nil];
    _coordinator =
        [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:_model];
    
    _parentContext = [[NSManagedObjectContext alloc]
                          initWithConcurrencyType:NSPrivateQueueConcurrencyType];
    [_parentContext performBlockAndWait:^{
        [_parentContext setPersistentStoreCoordinator:_coordinator];
        [_parentContext
                 setMergePolicy:NSMergeByPropertyObjectTrumpMergePolicy];
        }];
    
    _context = [[NSManagedObjectContext alloc]
                    initWithConcurrencyType:NSMainQueueConcurrencyType];
    [_context setParentContext:_parentContext];
    [_context setMergePolicy:NSMergeByPropertyObjectTrumpMergePolicy];
    
    _importContext = [[NSManagedObjectContext alloc]
                          initWithConcurrencyType:NSPrivateQueueConcurrencyType];
    [_importContext performBlockAndWait:^{
        [_importContext setPersistentStoreCoordinator:_coordinator];
        [_importContext setMergePolicy:NSMergeByPropertyObjectTrumpMergePolicy];
        [_importContext setUndoManager:nil]; // the default on iOS
        }];
    
    _sourceCoordinator = [[NSPersistentStoreCoordinator alloc]
                              initWithManagedObjectModel:_model];
    _sourceContext = [[NSManagedObjectContext alloc]
                          initWithConcurrencyType:NSPrivateQueueConcurrencyType];
    [_sourceContext performBlockAndWait:^{
        [_sourceContext setMergePolicy:NSMergeByPropertyObjectTrumpMergePolicy];
        [_sourceContext setPersistentStoreCoordinator:_sourceCoordinator];
        [_sourceContext setUndoManager:nil]; // the default on iOS
        }];
    return self;
}

- (void)loadStore {
    if (debug==1) {
        NSLog(@"Running %@ '%@'", self.class, NSStringFromSelector(_cmd));
    }
    if (_store) {return;} // Don't load store if it's already loaded
    NSDictionary *options =@{
          NSMigratePersistentStoresAutomaticallyOption:@YES
          ,NSInferMappingModelAutomaticallyOption:@YES
//          ,NSSQLitePragmasOption: @{@"journal_mode": @"DELETE"}
          };
    
    NSError *error = nil;
    _store = [_coordinator addPersistentStoreWithType:NSSQLiteStoreType
                  configuration:nil
                  URL:[self storeURL]
                  options:options error:&error];
    if (!_store) {NSLog(@"Failed to add store. Error: %@", error);abort();}
    else {if (debug==1) {NSLog(@"Successfully added store: %@", _store);}}
}

- (void)setupCoreData {
    if (debug==1) {
        NSLog(@"Running %@ '%@'", self.class, NSStringFromSelector(_cmd));
    }
    if (![self loadiCloudStore]) {
        [self setDefaultDataStoreAsInitialStore];
        [self loadStore];
        }
}

#pragma mark - SAVING
- (void)saveContext {
    if (debug==1) {
        NSLog(@"Running %@ '%@'", self.class, NSStringFromSelector(_cmd));
    }
    if ([_context hasChanges]) {
        NSError *error = nil;
        if ([_context save:&error]) {
            NSLog(@"_context SAVED changes to persistent store");
            } else {
                NSLog(@"Failed to save _context: %@", error);
                }
        } else {
            NSLog(@"SKIPPED _context save, there are no changes!");
            }
}

#pragma mark - DATA IMPORT
- (void)setDefaultDataStoreAsInitialStore {
    if (debug==1) {
        NSLog(@"Running %@ '%@'", self.class, NSStringFromSelector(_cmd));
    }
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if (![fileManager fileExistsAtPath:self.storeURL.path]) {
        NSURL *defaultDataURL =
                    [NSURL fileURLWithPath:[[NSBundle mainBundle]
                           pathForResource:@"DefaultData" ofType:@"sqlite"]];
        
        NSError *error;
        if (![fileManager copyItemAtURL:defaultDataURL
                                  toURL:self.storeURL
                                  error:&error]) {
            NSLog(@"DefaultData.sqlite copy FAIL: %@",
                                error.localizedDescription);
            }
        else {
            NSLog(@"A copy of DefaultData.sqlite was set as the initial store for %@",
                  self.storeURL.path);
            }
        }
}

#pragma mark - CORE DATA RESET
- (void)resetContext:(NSManagedObjectContext*)moc {
    [moc performBlockAndWait:^{
        [moc reset];
        }];
}

#pragma mark - UNIQUE ATTRIBUTE SELECTION (This code is Risk Manager data specific and is used when instantiating AGCCoreDataImporter)
- (NSDictionary*)selectedUniqueAttributes {
    if (debug==1) {
        NSLog(@"Running %@ '%@'", self.class, NSStringFromSelector(_cmd));
    }
    NSMutableArray *entities= [NSMutableArray new];
    NSMutableArray *attributes = [NSMutableArray new];
    
    // Select an attribute in each entity for uniqueness
    [entities addObject:@"Risk_group"];[attributes addObject:@"short_name"];
    //    [entities addObject:@"Unit"];[attributes addObject:@"name"];
    //    [entities addObject:@"LocationAtHome"];[attributes addObject:@"storedIn"];
    //    [entities addObject:@"LocationAtShop"];[attributes addObject:@"aisle"];
    
    NSDictionary *dictionary = [NSDictionary dictionaryWithObjects:attributes
                                                           forKeys:entities];
    return dictionary;
}

#pragma mark - DELEGATE: NSXMLParser (This code is Risk Manager data specific)
- (void)parser:(NSXMLParser *)parser
parseErrorOccurred:(NSError *)parseError {
    if (debug==1) {
        NSLog(@"Parser Error: %@", parseError.localizedDescription);
    }
}

- (void)parser:(NSXMLParser *)parser
didStartElement:(NSString *)elementName
  namespaceURI:(NSString *)namespaceURI
 qualifiedName:(NSString *)qName
    attributes:(NSDictionary *)attributeDict
{
    
    [self.importContext performBlockAndWait:^{
        
        // STEP 1: Process only the 'risk_group' element in the XML file
        if ([elementName isEqualToString:@"Risk_group"]) {
            
            // STEP 2: Prepare the Core Data Importer
            AGCCoreDataImporter *importer =
            [[AGCCoreDataImporter alloc] initWithUniqueAttributes:[self selectedUniqueAttributes]];
            
            // STEP 3a: Insert a unique 'Risk_group' object
            NSManagedObject *riskgroup =
            [importer insertBasicObjectInTargetEntity:@"Risk_group"
                                targetEntityAttribute:@"short_name"
                                   sourceXMLAttribute:@"short_name"
                                        attributeDict:attributeDict
                                              context:_importContext];
            
            // STEP 3b: Insert a unique 'Unit' object
            /*    NSManagedObject *unit =
             [importer insertBasicObjectInTargetEntity:@"Unit"
             targetEntityAttribute:@"name"
             sourceXMLAttribute:@"unit"
             attributeDict:attributeDict
             context:importContext];
             
             // STEP 3c: Insert a unique 'LocationAtHome' object
             NSManagedObject *locationAtHome =
             [importer insertBasicObjectInTargetEntity:@"LocationAtHome"
             targetEntityAttribute:@"storedIn"
             sourceXMLAttribute:@"locationathome"
             attributeDict:attributeDict
             context:importContext];
             
             // STEP 3d: Insert a unique 'LocationAtShop' object
             NSManagedObject *locationAtShop =
             [importer insertBasicObjectInTargetEntity:@"LocationAtShop"
             targetEntityAttribute:@"aisle"
             sourceXMLAttribute:@"locationatshop"
             attributeDict:attributeDict
             context:importContext];
             */
            // STEP 4: Create relationships
            //   [item setValue:unit forKey:@"unit"];
            //   [item setValue:locationAtHome forKey:@"locationAtHome"];
            //   [item setValue:locationAtShop forKey:@"locationAtShop"];
            
            // STEP 5: Save new objects to the persistent store.
            [AGCCoreDataImporter saveContext:_importContext];
            
            // STEP 6: Turn objects into faults to save memory
            [_importContext refreshObject:riskgroup mergeChanges:NO];
            //   [importContext refreshObject:unit mergeChanges:NO];
            //   [importContext refreshObject:locationAtHome mergeChanges:NO];
            //   [importContext refreshObject:locationAtShop mergeChanges:NO];
        }
    }];
}

#pragma mark - ICLOUD
- (BOOL)iCloudAccountIsSignedIn {
    if (debug==1) {
        NSLog(@"Running %@ '%@'", self.class, NSStringFromSelector(_cmd));
    }
    id token = [[NSFileManager defaultManager] ubiquityIdentityToken];
    if (token) {
        NSLog(@"** iCloud is SIGNED IN with token '%@' **", token);
        return YES;
        }
    NSLog(@"** iCloud is NOT SIGNED IN **");
    NSLog(@"--> Is iCloud Documents and Data enabled for a valid iCloud account on your Mac & iOS Device or iOS Simulator?");
    NSLog(@"--> Have you enabled the iCloud Capability in the Application Target?");
    NSLog(@"--> Is there a CODE_SIGN_ENTITLEMENTS Xcode warning that needs fixing? You may need to specifically choose a developer instead of using Automatic selection");
    NSLog(@"--> Are you using a Pre-iOS7 Simulator?");
    return NO;
}

- (BOOL)loadiCloudStore {
    if (debug==1) {
        NSLog(@"Running %@ '%@'", self.class, NSStringFromSelector(_cmd));
    }
    if (_iCloudStore) {return YES;} // Don't load iCloud store if it's already loaded
    
    NSDictionary *options = @{
                              NSMigratePersistentStoresAutomaticallyOption:@YES
                              ,NSInferMappingModelAutomaticallyOption:@YES
                              ,NSPersistentStoreUbiquitousContentNameKey:@"Risk-Management"
                              //,NSPersistentStoreUbiquitousContentURLKey:@"ChangeLogs" // Optional since iOS7
                              };
    NSError *error;
    _iCloudStore = [_coordinator addPersistentStoreWithType:NSSQLiteStoreType
                                             configuration:nil
                                                       URL:[self iCloudStoreURL]
                                                   options:options
                                                     error:&error];
    if (_iCloudStore) {
        NSLog(@"** The iCloud Store has been successfully configured at '%@' **",
                      _iCloudStore.URL.path);
        return YES;
        }
    NSLog(@"** FAILED to configure the iCloud Store : %@ **", error);
    return NO;
}

- (void)listenForStoreChanges {
    if (debug==1) {
        NSLog(@"Running %@ '%@'", self.class, NSStringFromSelector(_cmd));
    }
    NSNotificationCenter *dc = [NSNotificationCenter defaultCenter];
    [dc addObserver:self
            selector:@selector(storesWillChange:)
                name:NSPersistentStoreCoordinatorStoresWillChangeNotification
             object:_coordinator];
    
    [dc addObserver:self
         selector:@selector(storesDidChange:)
            name:NSPersistentStoreCoordinatorStoresDidChangeNotification
         object:_coordinator];
    
    [dc addObserver:self
         selector:@selector(persistentStoreDidImportUbiquitiousContentChanges:)
         name:NSPersistentStoreDidImportUbiquitousContentChangesNotification
         object:_coordinator];
}

- (void)storesWillChange:(NSNotification *)n {
    if (debug==1) {
        NSLog(@"Running %@ '%@'", self.class, NSStringFromSelector(_cmd));
    }
    [_importContext performBlockAndWait:^{
        [_importContext save:nil];
        [self resetContext:_importContext];
        }];
    [_context performBlockAndWait:^{
        [_context save:nil];
        [self resetContext:_context];
        }];
    [_parentContext performBlockAndWait:^{
        [_parentContext save:nil];
        [self resetContext:_parentContext];
        }];
    
    // Refresh UI
    [[NSNotificationCenter defaultCenter] postNotificationName:@"SomethingChanged"
                                                        object:nil
                                                      userInfo:nil];
}

- (void)storesDidChange:(NSNotification *)n {
    if (debug==1) {
        NSLog(@"Running %@ '%@'", self.class, NSStringFromSelector(_cmd));
    }
    // Refresh UI
    [[NSNotificationCenter defaultCenter] postNotificationName:@"SomethingChanged"
                                                        object:nil
                                                      userInfo:nil];
}

- (void)persistentStoreDidImportUbiquitiousContentChanges:(NSNotification*)n {
    if (debug==1) {
        NSLog(@"Running %@ '%@'", self.class, NSStringFromSelector(_cmd));
        }
    [_context performBlock:^{
            [_context mergeChangesFromContextDidSaveNotification:n];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"SomethingChanged"
                                                        object:nil];
        }];
}

@end
