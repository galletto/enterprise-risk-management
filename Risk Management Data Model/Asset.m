//
//  Asset.m
//  Enterprise Risk Management
//
//  Created by Alessandro on 14/04/14.
//  Copyright (c) 2014 ALARCATX. All rights reserved.
//

#import "Asset.h"
#import "Availability_req.h"
#import "Business_process.h"
#import "Data_classification.h"
#import "Integrity_req.h"
#import "Owner.h"
#import "Risk.h"
#import "Risk_group.h"
#import "Site.h"


@implementation Asset

@dynamic age;
@dynamic asset_custodian;
@dynamic asset_photo;
@dynamic code;
@dynamic data_retention;
@dynamic desc;
@dynamic format;
@dynamic initial_cost;
@dynamic is_business_confidential_critical;
@dynamic is_customer_confidential;
@dynamic is_intimate_data;
@dynamic is_personal_data;
@dynamic replacement_cost;
@dynamic short_name;
@dynamic value_to_business;
@dynamic id;
@dynamic updated_at;
@dynamic availability_req;
@dynamic business_process;
@dynamic data_classification;
@dynamic integrity_req;
@dynamic owner;
@dynamic risk_group;
@dynamic risks;
@dynamic site;

@end
