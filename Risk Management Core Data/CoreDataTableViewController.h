//
//  CoreDataTableViewController.h
//  v2.0
//
//  Created by Tim Roadley on 09/09/13.
//  Copyright (c) 2013 Tim Roadley. All rights reserved.
//
//  This class is free to use in production applications for owners of "Learning Core Data for iOS" by Tim Roadley
//

#import <UIKit/UIKit.h>
#import "CoreDataHelper.h"

@interface CoreDataTableViewController : UITableViewController

<NSFetchedResultsControllerDelegate, UISearchBarDelegate, UISearchDisplayDelegate>

@property (strong, nonatomic) NSFetchedResultsController *frc;
@property (strong, nonatomic) NSFetchedResultsController *searchFRC;
@property (strong, nonatomic) UISearchDisplayController *searchDC;

- (void)performFetch;
- (NSFetchedResultsController*)frcFromTV:(UITableView*)tableView;
- (UITableView*)TVFromFRC:(NSFetchedResultsController*)frc;

- (void)reloadSearchFRCForPredicate:(NSPredicate*)predicate
                         withEntity:(NSString*)entity
                          inContext:(NSManagedObjectContext*)context
                withSortDescriptors:(NSArray*)sortDescriptors
             withSectionNameKeyPath:(NSString*)sectionNameKeyPath;
- (void)configureSearch;

@end
