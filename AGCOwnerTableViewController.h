//
//  AGCOwnerTableViewController.h
//  Risk Mgmt
//
//  Created by Alessandro on 06/04/14.
//  Copyright (c) 2014 Alessandro Galletto. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CoreDataTableViewController.h"

@class Owner;
#import "AGCOwnerSelectionDelegate.h"

@interface AGCOwnerTableViewController : CoreDataTableViewController <UIActionSheetDelegate, UITableViewDelegate, UITextFieldDelegate>

@property (strong, nonatomic) UIActionSheet *deleteConfirmActionSheet;
@property (strong, nonatomic) NSIndexPath *deleteindexPath;
- (IBAction)newOwner:(UIBarButtonItem *)sender;
@property (nonatomic, assign) id<AGCOwnerSelectionDelegate> delegate;

@end

