//
//  Risk_group_photo.h
//  risk manager
//
//  Created by Alessandro on 25/04/14.
//  Copyright (c) 2014 ALARCATX. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Risk_group;

@interface Risk_group_photo : NSManagedObject

@property (nonatomic, retain) NSData * data;
@property (nonatomic, retain) Risk_group *risk_group;

@end
