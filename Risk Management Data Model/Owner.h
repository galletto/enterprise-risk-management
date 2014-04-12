//
//  Owner.h
//  Risk Mgmt
//
//  Created by Alessandro on 05/04/14.
//  Copyright (c) 2014 Alessandro Galletto. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Asset, Risk_group;

@interface Owner : NSManagedObject

@property (nonatomic, retain) NSString * email;
@property (nonatomic, retain) NSString * mobile;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSString * surname;
@property (nonatomic, retain) NSData * owner_photo;
@property (nonatomic, retain) NSSet *assets;
@property (nonatomic, retain) Risk_group *risk_group;
@end

@interface Owner (CoreDataGeneratedAccessors)

- (void)addAssetsObject:(Asset *)value;
- (void)removeAssetsObject:(Asset *)value;
- (void)addAssets:(NSSet *)values;
- (void)removeAssets:(NSSet *)values;

@end
