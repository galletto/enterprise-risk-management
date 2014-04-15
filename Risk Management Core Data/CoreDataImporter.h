//
//  CoreDataImporter.h
//  v2.0
//
//  Created by Tim Roadley on 09/09/13.
//  Copyright (c) 2013 Tim Roadley. All rights reserved.
//
//  This class is free to use in production applications for owners of "Learning Core Data for iOS" by Tim Roadley
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
@interface CoreDataImporter : NSObject
@property (nonatomic, retain) NSDictionary *entitiesWithUniqueAttributes;

+ (void)saveContext:(NSManagedObjectContext*)context;
- (CoreDataImporter*)initWithUniqueAttributes:(NSDictionary*)uniqueAttributes;
- (NSString*)uniqueAttributeForEntity:(NSString*)entity;

- (NSManagedObject*)insertUniqueObjectInTargetEntity:(NSString*)entity
                                uniqueAttributeValue:(NSString*)uniqueAttributeValue
                                     attributeValues:(NSDictionary*)attributeValues
                                           inContext:(NSManagedObjectContext*)context;

- (NSManagedObject*)insertBasicObjectInTargetEntity:(NSString*)entity
                              targetEntityAttribute:(NSString*)targetEntityAttribute
                                 sourceXMLAttribute:(NSString*)sourceXMLAttribute
                                      attributeDict:(NSDictionary*)attributeDict
                                            context:(NSManagedObjectContext*)context;

- (void)deepCopyEntities:(NSArray*)entities
             fromContext:(NSManagedObjectContext*)sourceContext
               toContext:(NSManagedObjectContext*)targetContext;
@end
