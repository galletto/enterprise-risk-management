//
//  AGCOwnerSelectionDelegate.h
//  risk manager
//
//  Created by Alessandro on 27/04/14.
//  Copyright (c) 2014 ALARCATX. All rights reserved.
//

#import <Foundation/Foundation.h>
@class Owner;

@protocol AGCOwnerSelectionDelegate <NSObject>

@required
-(void)selectedOwner:(NSManagedObjectID *)newOwnerID;
@end
