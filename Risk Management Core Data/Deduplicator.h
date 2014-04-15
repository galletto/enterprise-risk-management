//
//  Deduplicator.h
//  v2.0
//
//  Created by Tim Roadley on 09/09/13.
//  Copyright (c) 2013 Tim Roadley. All rights reserved.
//
//  This class is free to use in production applications for owners of "Learning Core Data for iOS" by Tim Roadley
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@interface Deduplicator : NSObject

+ (void)deDuplicateEntityWithName:(NSString*)entityName
          withUniqueAttributeName:(NSString*)uniqueAttributeName
                withImportContext:(NSManagedObjectContext*)importContext;

@end
