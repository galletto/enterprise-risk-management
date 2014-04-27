//
//  AGCGlobalVariables.h
//  risk manager
//
//  Created by Alessandro on 27/04/14.
//  Copyright (c) 2014 ALARCATX. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AGCGlobalVariables : NSObject{
    NSManagedObjectID *selectedRiskGroupID;
    NSString *selectedRiskGroupUUID;
}

@property (nonatomic, retain) NSManagedObjectID *selectedRiskGroupID;
@property (nonatomic, retain) NSString *selectedRiskGroupUUID;

+ (id) sharedManager;

@end
