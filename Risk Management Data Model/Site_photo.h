//
//  Site_photo.h
//  risk manager
//
//  Created by Alessandro on 25/04/14.
//  Copyright (c) 2014 ALARCATX. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Site;

@interface Site_photo : NSManagedObject

@property (nonatomic, retain) NSData * data;
@property (nonatomic, retain) Site *site;

@end
