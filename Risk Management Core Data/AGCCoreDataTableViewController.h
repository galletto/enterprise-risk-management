//
//  AGCCoreDataTableViewController.h
//  Risk Mgmt
//
//  Created by Alessandro on 05/04/14.
//  Copyright (c) 2014 Alessandro Galletto. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AGCCoreDataHelper.h"

@interface AGCCoreDataTableViewController : UITableViewController <NSFetchedResultsControllerDelegate>

@property (strong, nonatomic) NSFetchedResultsController *fetchedresultscontroller;
- (void)performFetch;

@end