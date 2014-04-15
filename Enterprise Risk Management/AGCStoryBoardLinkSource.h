//
//  AGCStoryBoardLinkSource.h
//  Enterprise Risk Management
//
//  Created by Alessandro on 15/04/14.
//  Copyright (c) 2014 ALARCATX. All rights reserved.
//

#import "AGCRiskGroupTableViewCell.h"

#import <Foundation/Foundation.h>

@protocol AGCStoryboardLinkSource <NSObject>

@optional

- (BOOL)needsTopLayoutGuide;

- (BOOL)needsBottomLayoutGuide;

@end