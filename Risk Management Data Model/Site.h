//
//  Site.h
//  risk manager
//
//  Created by Alessandro on 25/04/14.
//  Copyright (c) 2014 ALARCATX. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Asset, Site_photo;

@interface Site : NSManagedObject

@property (nonatomic, retain) NSString * address;
@property (nonatomic, retain) NSString * city;
@property (nonatomic, retain) NSString * code;
@property (nonatomic, retain) NSString * country;
@property (nonatomic, retain) NSString * desc;
@property (nonatomic, retain) NSString * id;
@property (nonatomic, retain) NSNumber * latitude;
@property (nonatomic, retain) NSNumber * longitude;
@property (nonatomic, retain) NSString * short_name;
@property (nonatomic, retain) NSString * state;
@property (nonatomic, retain) id thumbnail;
@property (nonatomic, retain) NSDate * updated_at;
@property (nonatomic, retain) NSString * zip;
@property (nonatomic, retain) NSSet *assets;
@property (nonatomic, retain) Site_photo *photo;
@end

@interface Site (CoreDataGeneratedAccessors)

- (void)addAssetsObject:(Asset *)value;
- (void)removeAssetsObject:(Asset *)value;
- (void)addAssets:(NSSet *)values;
- (void)removeAssets:(NSSet *)values;

@end
