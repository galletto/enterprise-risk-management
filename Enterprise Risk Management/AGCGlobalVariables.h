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
    NSString *selectedRiskGroupTitle;
}

@property (nonatomic, retain) NSManagedObjectID *selectedRiskGroupID;
@property (nonatomic, retain) NSString *selectedRiskGroupUUID;
@property (nonatomic, retain) NSString *selectedRiskGroupCode;
@property (nonatomic, retain) NSString *selectedRiskGroupTitle;

+ (id) sharedManager;

@end
