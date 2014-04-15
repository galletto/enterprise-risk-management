//
//  Risk_group.h
//  Enterprise Risk Management
//
//  Created by Alessandro on 15/04/14.
//  Copyright (c) 2014 ALARCATX. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Asset, Asset_care_criteria, Availability_req, Business_process, Data_classification, Integrity_req, Owner, Risk_level, Risk_matrix;

@interface Risk_group : NSManagedObject

@property (nonatomic, retain) NSString * code;
@property (nonatomic, retain) NSString * company;
@property (nonatomic, retain) NSDate * created_at;
@property (nonatomic, retain) NSString * created_by;
@property (nonatomic, retain) NSString * desc;
@property (nonatomic, retain) NSNumber * id;
@property (nonatomic, retain) NSString * short_name;
@property (nonatomic, retain) NSDate * updated_at;
@property (nonatomic, retain) NSString * updated_by;
@property (nonatomic, retain) Asset_care_criteria *asset_care_criteria;
@property (nonatomic, retain) NSSet *assets;
@property (nonatomic, retain) NSSet *availability_reqs;
@property (nonatomic, retain) NSSet *business_processes;
@property (nonatomic, retain) NSSet *data_classifications;
@property (nonatomic, retain) NSSet *integrity_reqs;
@property (nonatomic, retain) NSSet *owners;
@property (nonatomic, retain) NSSet *risk_levels;
@property (nonatomic, retain) NSSet *risk_matrixs;
@end

@interface Risk_group (CoreDataGeneratedAccessors)

- (void)addAssetsObject:(Asset *)value;
- (void)removeAssetsObject:(Asset *)value;
- (void)addAssets:(NSSet *)values;
- (void)removeAssets:(NSSet *)values;

- (void)addAvailability_reqsObject:(Availability_req *)value;
- (void)removeAvailability_reqsObject:(Availability_req *)value;
- (void)addAvailability_reqs:(NSSet *)values;
- (void)removeAvailability_reqs:(NSSet *)values;

- (void)addBusiness_processesObject:(Business_process *)value;
- (void)removeBusiness_processesObject:(Business_process *)value;
- (void)addBusiness_processes:(NSSet *)values;
- (void)removeBusiness_processes:(NSSet *)values;

- (void)addData_classificationsObject:(Data_classification *)value;
- (void)removeData_classificationsObject:(Data_classification *)value;
- (void)addData_classifications:(NSSet *)values;
- (void)removeData_classifications:(NSSet *)values;

- (void)addIntegrity_reqsObject:(Integrity_req *)value;
- (void)removeIntegrity_reqsObject:(Integrity_req *)value;
- (void)addIntegrity_reqs:(NSSet *)values;
- (void)removeIntegrity_reqs:(NSSet *)values;

- (void)addOwnersObject:(Owner *)value;
- (void)removeOwnersObject:(Owner *)value;
- (void)addOwners:(NSSet *)values;
- (void)removeOwners:(NSSet *)values;

- (void)addRisk_levelsObject:(Risk_level *)value;
- (void)removeRisk_levelsObject:(Risk_level *)value;
- (void)addRisk_levels:(NSSet *)values;
- (void)removeRisk_levels:(NSSet *)values;

- (void)addRisk_matrixsObject:(Risk_matrix *)value;
- (void)removeRisk_matrixsObject:(Risk_matrix *)value;
- (void)addRisk_matrixs:(NSSet *)values;
- (void)removeRisk_matrixs:(NSSet *)values;

@end
