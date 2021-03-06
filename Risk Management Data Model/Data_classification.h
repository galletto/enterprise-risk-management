//
//  Data_classification.h
//  risk manager
//
//  Created by Alessandro on 25/04/14.
//  Copyright (c) 2014 ALARCATX. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Asset, Asset_care_criteria, Risk_group;

@interface Data_classification : NSManagedObject

@property (nonatomic, retain) NSString * code;
@property (nonatomic, retain) NSString * desc;
@property (nonatomic, retain) NSString * disposal_of_electronic_information;
@property (nonatomic, retain) NSString * disposal_of_physical_medium;
@property (nonatomic, retain) NSString * id;
@property (nonatomic, retain) NSString * labelling;
@property (nonatomic, retain) NSString * removable_media;
@property (nonatomic, retain) NSString * short_name;
@property (nonatomic, retain) NSString * storage;
@property (nonatomic, retain) NSString * transmission;
@property (nonatomic, retain) NSDate * updated_at;
@property (nonatomic, retain) NSSet *asset_care_criterias;
@property (nonatomic, retain) NSSet *assets;
@property (nonatomic, retain) Risk_group *risk_group;
@end

@interface Data_classification (CoreDataGeneratedAccessors)

- (void)addAsset_care_criteriasObject:(Asset_care_criteria *)value;
- (void)removeAsset_care_criteriasObject:(Asset_care_criteria *)value;
- (void)addAsset_care_criterias:(NSSet *)values;
- (void)removeAsset_care_criterias:(NSSet *)values;

- (void)addAssetsObject:(Asset *)value;
- (void)removeAssetsObject:(Asset *)value;
- (void)addAssets:(NSSet *)values;
- (void)removeAssets:(NSSet *)values;

@end
