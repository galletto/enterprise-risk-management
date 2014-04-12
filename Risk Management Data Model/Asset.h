//
//  Asset.h
//  Risk Mgmt
//
//  Created by Alessandro on 05/04/14.
//  Copyright (c) 2014 Alessandro Galletto. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Availability_req, Business_process, Data_classification, Integrity_req, Owner, Risk, Risk_group, Site;

@interface Asset : NSManagedObject

@property (nonatomic, retain) NSString * asset_custodian;
@property (nonatomic, retain) NSData * asset_photo;
@property (nonatomic, retain) NSString * code;
@property (nonatomic, retain) NSString * data_retention;
@property (nonatomic, retain) NSString * desc;
@property (nonatomic, retain) NSNumber * is_business_confidential_critical;
@property (nonatomic, retain) NSNumber * is_customer_confidential;
@property (nonatomic, retain) NSNumber * is_intimate_data;
@property (nonatomic, retain) NSNumber * is_personal_data;
@property (nonatomic, retain) NSString * short_name;
@property (nonatomic, retain) NSString * format;
@property (nonatomic, retain) NSString * value_to_business;
@property (nonatomic, retain) NSString * initial_cost;
@property (nonatomic, retain) NSString * age;
@property (nonatomic, retain) NSString * replacement_cost;
@property (nonatomic, retain) Availability_req *availability_req;
@property (nonatomic, retain) Business_process *business_process;
@property (nonatomic, retain) Data_classification *data_classification;
@property (nonatomic, retain) Integrity_req *integrity_req;
@property (nonatomic, retain) Owner *owner;
@property (nonatomic, retain) Risk_group *risk_group;
@property (nonatomic, retain) NSSet *risks;
@property (nonatomic, retain) Site *site;
@end

@interface Asset (CoreDataGeneratedAccessors)

- (void)addRisksObject:(Risk *)value;
- (void)removeRisksObject:(Risk *)value;
- (void)addRisks:(NSSet *)values;
- (void)removeRisks:(NSSet *)values;

@end
