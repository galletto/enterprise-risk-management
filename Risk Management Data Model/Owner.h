//
//  Owner.h
//  risk manager
//
//  Created by Alessandro on 25/04/14.
//  Copyright (c) 2014 ALARCATX. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Asset, Owner_photo, Risk_group;

@interface Owner : NSManagedObject

@property (nonatomic, retain) NSString * email;
@property (nonatomic, retain) NSString * id;
@property (nonatomic, retain) NSString * mobile;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSString * surname;
@property (nonatomic, retain) id thumbnail;
@property (nonatomic, retain) NSDate * updated_at;
@property (nonatomic, retain) NSSet *assets;
@property (nonatomic, retain) Owner_photo *photo;
@property (nonatomic, retain) Risk_group *risk_group;
@end

@interface Owner (CoreDataGeneratedAccessors)

- (void)addAssetsObject:(Asset *)value;
- (void)removeAssetsObject:(Asset *)value;
- (void)addAssets:(NSSet *)values;
- (void)removeAssets:(NSSet *)values;

@end
