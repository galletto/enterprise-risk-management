//
//  Faulter.m
//  v2.0
//
//  Created by Tim Roadley on 09/09/13.
//  Copyright (c) 2013 Tim Roadley. All rights reserved.
//
//  This class is free to use in production applications for owners of "Learning Core Data for iOS" by Tim Roadley
//

#import "Faulter.h"
@implementation Faulter

+ (void)faultObjectWithID:(NSManagedObjectID*)objectID
                inContext:(NSManagedObjectContext*)context {
    
    if (!objectID || !context) {
        return;
    }
    
    [context performBlockAndWait:^{
        
        NSManagedObject *object = [context objectWithID:objectID];
        
        if (object.hasChanges) {
            NSError *error = nil;
            if (![context save:&error]) {
                NSLog(@"ERROR saving: %@", error);
            }
        }
        
        if (!object.isFault) {
            
            NSLog(@"Faulting object %@ in context %@", object.objectID, context);
            [context refreshObject:object mergeChanges:NO];
        } else {
            NSLog(@"Skipped faulting an object that is already a fault");
        }
        
        // Repeat the process if the context has a parent
        if (context.parentContext) {
            [self faultObjectWithID:objectID inContext:context.parentContext];
        }
    }];
}
@end
