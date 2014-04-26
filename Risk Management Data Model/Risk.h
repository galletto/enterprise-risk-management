//
//  Risk.h
//  risk manager
//
//  Created by Alessandro on 25/04/14.
//  Copyright (c) 2014 ALARCATX. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Asset, Impact, Likelihood, Threat;

@interface Risk : NSManagedObject

@property (nonatomic, retain) NSString * code;
@property (nonatomic, retain) NSString * desc;
@property (nonatomic, retain) NSString * effectivity;
@property (nonatomic, retain) NSString * further_accions_planned;
@property (nonatomic, retain) NSString * id;
@property (nonatomic, retain) NSNumber * orderingValue;
@property (nonatomic, retain) NSString * other_improvements;
@property (nonatomic, retain) NSString * risk_managemrnt;
@property (nonatomic, retain) NSString * short_name;
@property (nonatomic, retain) NSDate * updated_at;
@property (nonatomic, retain) Asset *asset;
@property (nonatomic, retain) Impact *impact;
@property (nonatomic, retain) Likelihood *likelihood;
@property (nonatomic, retain) Impact *new_impact;
@property (nonatomic, retain) Likelihood *new_likelihood;
@property (nonatomic, retain) Threat *threat;

@end
