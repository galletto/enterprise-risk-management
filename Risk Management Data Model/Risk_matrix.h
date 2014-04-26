//
//  Risk_matrix.h
//  risk manager
//
//  Created by Alessandro on 25/04/14.
//  Copyright (c) 2014 ALARCATX. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Impact, Likelihood, Risk_group;

@interface Risk_matrix : NSManagedObject

@property (nonatomic, retain) NSString * id;
@property (nonatomic, retain) NSNumber * risk_score;
@property (nonatomic, retain) NSDate * updated_at;
@property (nonatomic, retain) Impact *impact;
@property (nonatomic, retain) Likelihood *likelihood;
@property (nonatomic, retain) Risk_group *risk_group;

@end
