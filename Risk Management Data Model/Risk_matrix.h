//
//  Risk_matrix.h
//  Enterprise Risk Management
//
//  Created by Alessandro on 14/04/14.
//  Copyright (c) 2014 ALARCATX. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Impact, Likelihood, Risk_group;

@interface Risk_matrix : NSManagedObject

@property (nonatomic, retain) NSNumber * risk_score;
@property (nonatomic, retain) NSNumber * id;
@property (nonatomic, retain) NSDate * updated_at;
@property (nonatomic, retain) Impact *impact;
@property (nonatomic, retain) Likelihood *likelihood;
@property (nonatomic, retain) Risk_group *risk_group;

@end
