//
//  Asset_care_criteria.h
//  Enterprise Risk Management
//
//  Created by Alessandro on 14/04/14.
//  Copyright (c) 2014 ALARCATX. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Availability_req, Data_classification, Integrity_req, Risk_group;

@interface Asset_care_criteria : NSManagedObject

@property (nonatomic, retain) NSNumber * is_business_confidential_critical;
@property (nonatomic, retain) NSNumber * is_customer_confidential;
@property (nonatomic, retain) NSNumber * is_intimate_data;
@property (nonatomic, retain) NSNumber * is_personal_data;
@property (nonatomic, retain) NSNumber * id;
@property (nonatomic, retain) NSDate * updated_at;
@property (nonatomic, retain) Availability_req *availability_req;
@property (nonatomic, retain) Data_classification *data_classification;
@property (nonatomic, retain) Integrity_req *integrity_req;
@property (nonatomic, retain) Risk_group *risk_group;

@end
