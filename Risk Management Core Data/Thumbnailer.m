//
//  Thumbnailer.m
//  v2.0
//
//  Created by Tim Roadley on 09/09/13.
//  Copyright (c) 2013 Tim Roadley. All rights reserved.
//
//  This class is free to use in production applications for owners of "Learning Core Data for iOS" by Tim Roadley
//

#import "Thumbnailer.h"
#import "Faulter.h"

@implementation Thumbnailer
#define debug 0

+ (void)createMissingThumbnailsForEntityName:(NSString*)entityName
                  withThumbnailAttributeName:(NSString*)thumbnailAttributeName
                   withPhotoRelationshipName:(NSString*)photoRelationshipName
                      withPhotoAttributeName:(NSString*)photoAttributeName
                         withSortDescriptors:(NSArray*)sortDescriptors
                           withImportContext:(NSManagedObjectContext*)importContext {
    if (debug==1) {
        NSLog(@"Running %@ '%@'", self.class, NSStringFromSelector(_cmd));
    }
    [importContext performBlock:^{
        
        NSFetchRequest *request =
        [NSFetchRequest fetchRequestWithEntityName:entityName];
        request.predicate = [NSPredicate predicateWithFormat:@"%K==nil && %K.%K!=nil", thumbnailAttributeName, photoRelationshipName, photoAttributeName];
        request.sortDescriptors = sortDescriptors;
        request.fetchBatchSize = 15;
        NSError *error;
        NSArray *missingThumbnails = [importContext executeFetchRequest:request error:&error];
        if (error) {NSLog(@"Error: %@", error.localizedDescription);}
        
        for (NSManagedObject *object in missingThumbnails) {
            
            NSManagedObject *photoObject =
            [object valueForKey:photoRelationshipName];
            
            if (![object valueForKey:thumbnailAttributeName] && [photoObject valueForKey:photoAttributeName]) {
                
                // Create Thumbnail
                UIImage *photo = [UIImage imageWithData:[photoObject valueForKey:photoAttributeName]];
                CGSize size = CGSizeMake(66, 66);
                UIGraphicsBeginImageContextWithOptions(size, NO, 0.0);
                [photo drawInRect:CGRectMake(0, 0, size.width, size.height)];
                UIImage *thumbnail = UIGraphicsGetImageFromCurrentImageContext();
                UIGraphicsEndImageContext();
                [object setValue:UIImagePNGRepresentation(thumbnail)
                          forKey:thumbnailAttributeName];
                
                // Fault photo object out of memory
                [Faulter faultObjectWithID:photoObject.objectID inContext:importContext];
                [Faulter faultObjectWithID:object.objectID inContext:importContext];
                
                // Remove unused variables
                photo = nil;
                thumbnail = nil;
            }
        }
    }];
}
@end
