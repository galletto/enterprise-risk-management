//
//  Thumbnailer.h
//  v2.0
//
//  Created by Tim Roadley on 09/09/13.
//  Copyright (c) 2013 Tim Roadley. All rights reserved.
//
//  This class is free to use in production applications for owners of "Learning Core Data for iOS" by Tim Roadley
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@interface Thumbnailer : NSObject

+ (void)createMissingThumbnailsForEntityName:(NSString*)entityName
                  withThumbnailAttributeName:(NSString*)thumbnailAttributeName
                   withPhotoRelationshipName:(NSString*)photoRelationshipName
                      withPhotoAttributeName:(NSString*)photoAttributeName
                         withSortDescriptors:(NSArray*)sortDescriptors
                           withImportContext:(NSManagedObjectContext*)importContext;
@end
