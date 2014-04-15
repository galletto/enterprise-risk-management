//
//  Threat.h
//  Enterprise Risk Management
//
//  Created by Alessandro on 15/04/14.
//  Copyright (c) 2014 ALARCATX. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Risk;

@interface Threat : NSManagedObject

@property (nonatomic, retain) NSString * code;
@property (nonatomic, retain) NSString * desc;
@property (nonatomic, retain) NSNumber * id;
@property (nonatomic, retain) NSString * short_name;
@property (nonatomic, retain) NSString * threat_vulnerability;
@property (nonatomic, retain) NSDate * updated_at;
@property (nonatomic, retain) NSSet *risks;
@end

@interface Threat (CoreDataGeneratedAccessors)

- (void)addRisksObject:(Risk *)value;
- (void)removeRisksObject:(Risk *)value;
- (void)addRisks:(NSSet *)values;
- (void)removeRisks:(NSSet *)values;

@end
