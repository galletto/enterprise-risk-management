//
//  Asset_photo.h
//  risk manager
//
//  Created by Alessandro on 25/04/14.
//  Copyright (c) 2014 ALARCATX. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Asset;

@interface Asset_photo : NSManagedObject

@property (nonatomic, retain) NSData * data;
@property (nonatomic, retain) Asset *asset;

@end
