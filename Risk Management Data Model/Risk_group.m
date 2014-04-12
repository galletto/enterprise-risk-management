//
//  Risk_group.m
//  Risk Mgmt
//
//  Created by Alessandro on 05/04/14.
//  Copyright (c) 2014 Alessandro Galletto. All rights reserved.
//

#import "Risk_group.h"
#import "Asset.h"
#import "Asset_care_criteria.h"
#import "Availability_req.h"
#import "Business_process.h"
#import "Data_classification.h"
#import "Integrity_req.h"
#import "Owner.h"
#import "Risk_level.h"
#import "Risk_matrix.h"


@implementation Risk_group

@dynamic code;
@dynamic created_at;
@dynamic created_by;
@dynamic desc;
@dynamic short_name;
@dynamic updated_at;
@dynamic updated_by;
@dynamic asset_care_criteria;
@dynamic assets;
@dynamic availability_reqs;
@dynamic business_processes;
@dynamic data_classifications;
@dynamic integrity_reqs;
@dynamic owners;
@dynamic risk_levels;
@dynamic risk_matrixs;

@end
