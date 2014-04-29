//
//  AGCRiskGroupTableViewController.h
//  Risk Mgmt
//
//  Created by Alessandro on 06/04/14.
//  Copyright (c) 2014 Alessandro Galletto. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CoreDataTableViewController.h"

@interface AGCRiskGroupTableViewController : CoreDataTableViewController <UIActionSheetDelegate, UITableViewDelegate, UITextFieldDelegate>

@property (strong, nonatomic) UIActionSheet *deleteConfirmActionSheet;
@property (strong, nonatomic) NSIndexPath *deleteindexPath;
@property (strong, nonatomic) NSIndexPath *selectedindexPath;

@end
