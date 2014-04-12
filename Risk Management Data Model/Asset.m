//
//  Asset.m
//  Risk Mgmt
//
//  Created by Alessandro on 05/04/14.
//  Copyright (c) 2014 Alessandro Galletto. All rights reserved.
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

@dynamic asset_custodian;
@dynamic asset_photo;
@dynamic code;
@dynamic data_retention;
@dynamic desc;
@dynamic is_business_confidential_critical;
@dynamic is_customer_confidential;
@dynamic is_intimate_data;
@dynamic is_personal_data;
@dynamic short_name;
@dynamic format;
@dynamic value_to_business;
@dynamic initial_cost;
@dynamic age;
@dynamic replacement_cost;
@dynamic availability_req;
@dynamic business_process;
@dynamic data_classification;
@dynamic integrity_req;
@dynamic owner;
@dynamic risk_group;
@dynamic risks;
@dynamic site;

@end
