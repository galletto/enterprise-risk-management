//
//  AGCRiskGroupTableViewController.h
//  Risk Mgmt
//
//  Created by Alessandro on 06/04/14.
//  Copyright (c) 2014 Alessandro Galletto. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CoreDataTableViewController.h"

@interface AGCRiskGroupTableViewController : CoreDataTableViewController <UIActionSheetDelegate>

@property (strong, nonatomic) UIActionSheet *clearConfirmActionSheet;

@end
