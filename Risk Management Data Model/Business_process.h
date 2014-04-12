//
//  Business_process.h
//  Risk Mgmt
//
//  Created by Alessandro on 05/04/14.
//  Copyright (c) 2014 Alessandro Galletto. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Asset, Risk_group;

@interface Business_process : NSManagedObject

@property (nonatomic, retain) NSString * code;
@property (nonatomic, retain) NSString * desc;
@property (nonatomic, retain) NSString * short_name;
@property (nonatomic, retain) NSSet *assets;
@property (nonatomic, retain) Risk_group *risk_group;
@end

@interface Business_process (CoreDataGeneratedAccessors)

- (void)addAssetsObject:(Asset *)value;
- (void)removeAssetsObject:(Asset *)value;
- (void)addAssets:(NSSet *)values;
- (void)removeAssets:(NSSet *)values;

@end
