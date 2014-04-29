//
//  AGCGlobalVariables.m
//  risk manager
//
//  Created by Alessandro on 27/04/14.
//  Copyright (c) 2014 ALARCATX. All rights reserved.
//

#import "AGCGlobalVariables.h"

@implementation AGCGlobalVariables

@synthesize selectedRiskGroupID;
@synthesize selectedRiskGroupUUID;
@synthesize selectedRiskGroupCode;
@synthesize selectedRiskGroupTitle;

+ (id)sharedManager {
    static AGCGlobalVariables *sharedMyManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedMyManager = [[self alloc] init];
    });
    return sharedMyManager;
}

- (id)init {
    if (self = [super init]) {
        selectedRiskGroupID = nil;
        selectedRiskGroupUUID = nil;
        selectedRiskGroupCode = nil;
        selectedRiskGroupTitle = nil;
    }
    return self;
}

- (void)dealloc {
    // Should never be called, but just here for clarity really.
}

@end
