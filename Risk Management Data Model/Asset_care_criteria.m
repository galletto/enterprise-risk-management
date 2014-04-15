//
//  Asset_care_criteria.m
//  Enterprise Risk Management
//
//  Created by Alessandro on 14/04/14.
//  Copyright (c) 2014 ALARCATX. All rights reserved.
//

#import "Asset_care_criteria.h"
#import "Availability_req.h"
#import "Data_classification.h"
#import "Integrity_req.h"
#import "Risk_group.h"


@implementation Asset_care_criteria

@dynamic is_business_confidential_critical;
@dynamic is_customer_confidential;
@dynamic is_intimate_data;
@dynamic is_personal_data;
@dynamic id;
@dynamic updated_at;
@dynamic availability_req;
@dynamic data_classification;
@dynamic integrity_req;
@dynamic risk_group;

@end
