//
//  Likelihood.h
//  Enterprise Risk Management
//
//  Created by Alessandro on 15/04/14.
//  Copyright (c) 2014 ALARCATX. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Risk, Risk_matrix;

@interface Likelihood : NSManagedObject

@property (nonatomic, retain) NSString * code;
@property (nonatomic, retain) NSString * desc;
@property (nonatomic, retain) NSNumber * id;
@property (nonatomic, retain) NSString * short_name;
@property (nonatomic, retain) NSDate * updated_at;
@property (nonatomic, retain) NSSet *risk_matrixs;
@property (nonatomic, retain) NSSet *risks;
@property (nonatomic, retain) NSSet *risks_new;
@end

@interface Likelihood (CoreDataGeneratedAccessors)

- (void)addRisk_matrixsObject:(Risk_matrix *)value;
- (void)removeRisk_matrixsObject:(Risk_matrix *)value;
- (void)addRisk_matrixs:(NSSet *)values;
- (void)removeRisk_matrixs:(NSSet *)values;

- (void)addRisksObject:(Risk *)value;
- (void)removeRisksObject:(Risk *)value;
- (void)addRisks:(NSSet *)values;
- (void)removeRisks:(NSSet *)values;

- (void)addRisks_newObject:(Risk *)value;
- (void)removeRisks_newObject:(Risk *)value;
- (void)addRisks_new:(NSSet *)values;
- (void)removeRisks_new:(NSSet *)values;

@end
