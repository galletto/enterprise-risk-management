//
//  Asset_care_criteria.m
//  Risk Mgmt
//
//  Created by Alessandro on 05/04/14.
//  Copyright (c) 2014 Alessandro Galletto. All rights reserved.
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
@dynamic availability_req;
@dynamic data_classification;
@dynamic integrity_req;
@dynamic risk_group;

@end
