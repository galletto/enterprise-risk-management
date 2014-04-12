//
//  Risk_level.h
//  Risk Mgmt
//
//  Created by Alessandro on 05/04/14.
//  Copyright (c) 2014 Alessandro Galletto. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Risk_group;

@interface Risk_level : NSManagedObject

@property (nonatomic, retain) NSString * desc;
@property (nonatomic, retain) NSNumber * risk_score_max;
@property (nonatomic, retain) NSNumber * risk_score_min;
@property (nonatomic, retain) NSString * short_name;
@property (nonatomic, retain) NSString * action_required;
@property (nonatomic, retain) Risk_group *risk_group;

@end
