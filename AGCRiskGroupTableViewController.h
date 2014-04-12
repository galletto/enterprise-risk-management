//
//  AGCRiskGroupTableViewController.h
//  Risk Mgmt
//
//  Created by Alessandro on 06/04/14.
//  Copyright (c) 2014 Alessandro Galletto. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AGCCoreDataTableViewController.h"

@interface AGCRiskGroupTableViewController : AGCCoreDataTableViewController <UIActionSheetDelegate>

@property (strong, nonatomic) UIActionSheet *clearConfirmActionSheet;

@end
