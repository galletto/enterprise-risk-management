//
//  AGCCoreDataTableViewController.m
//  Risk Mgmt
//
//  Created by Alessandro on 05/04/14.
//  Copyright (c) 2014 Alessandro Galletto. All rights reserved.
//

#import "AGCCoreDataTableViewController.h"

@interface AGCCoreDataTableViewController ()

@end

@implementation AGCCoreDataTableViewController

#define debug 1

#pragma mark - FETCHING
- (void)performFetch {
    if (debug==1) {
        NSLog(@"Running %@ '%@'", self.class, NSStringFromSelector(_cmd));
    }
    
    if (self.fetchedresultscontroller) {
        [self.fetchedresultscontroller.managedObjectContext performBlockAndWait:^{
            NSError *error = nil;
            if (![self.fetchedresultscontroller performFetch:&error]) {
                
                NSLog(@"Failed to perform fetch: %@", error);
                }
            [self.tableView reloadData];
            }];
        } else {
            NSLog(@"Failed to fetch, the fetched results controller is nil.");
            }
}


#pragma mark - DATASOURCE: UITableView
- (NSInteger)tableView:(UITableView *)tableView
 numberOfRowsInSection:(NSInteger)section {
    if (debug==1) {
        NSLog(@"Running %@ '%@'", self.class, NSStringFromSelector(_cmd));
    }
    return [[self.fetchedresultscontroller.sections objectAtIndex:section] numberOfObjects];
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    if (debug==1) {
        NSLog(@"Running %@ '%@'", self.class, NSStringFromSelector(_cmd));
    }
        return [[self.fetchedresultscontroller sections] count];
    }
- (NSInteger)tableView:(UITableView *)tableView
sectionForSectionIndexTitle:(NSString *)title
               atIndex:(NSInteger)index {
    if (debug==1) {
        NSLog(@"Running %@ '%@'", self.class, NSStringFromSelector(_cmd));
    }
    return [self.fetchedresultscontroller sectionForSectionIndexTitle:title atIndex:index];
}
- (NSString *)tableView:(UITableView *)tableView
titleForHeaderInSection:(NSInteger)section {
    if (debug==1) {
        NSLog(@"Running %@ '%@'", self.class, NSStringFromSelector(_cmd));
    }
    return [[[self.fetchedresultscontroller sections] objectAtIndex:section] name];
}
- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView {
    if (debug==1) {
        NSLog(@"Running %@ '%@'", self.class, NSStringFromSelector(_cmd));
    }
    return [self.fetchedresultscontroller sectionIndexTitles];
}
    
#pragma mark - DELEGATE: NSFetchedResultsController
- (void)controllerWillChangeContent:(NSFetchedResultsController *)controller
{if (debug==1) {
    NSLog(@"Running %@ '%@'", self.class, NSStringFromSelector(_cmd));
}
    [self.tableView beginUpdates];
}
- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller
{if (debug==1) {
    NSLog(@"Running %@ '%@'", self.class, NSStringFromSelector(_cmd));
}
    [self.tableView endUpdates];
}
    
    
    
            
- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)controller:(NSFetchedResultsController *)controller
didChangeSection:(id <NSFetchedResultsSectionInfo>)sectionInfo
atIndex:(NSUInteger)sectionIndex
forChangeType:(NSFetchedResultsChangeType)type {
    
    if (debug==1) {
        NSLog(@"Running %@ '%@'", self.class, NSStringFromSelector(_cmd));
    }
    switch(type) {
        case NSFetchedResultsChangeInsert:
            
            [self.tableView insertSections:[NSIndexSet indexSetWithIndex:sectionIndex]
              withRowAnimation:UITableViewRowAnimationFade];
            break;
        case NSFetchedResultsChangeDelete:
            [self.tableView deleteSections:[NSIndexSet indexSetWithIndex:sectionIndex]
             withRowAnimation:UITableViewRowAnimationFade];
            break;
    }
}
- (void)controller:(NSFetchedResultsController *)controller
didChangeObject:(id)anObject
atIndexPath:(NSIndexPath *)indexPath
forChangeType:(NSFetchedResultsChangeType)type
newIndexPath:(NSIndexPath *)newIndexPath {
    
    if (debug==1) {
        NSLog(@"Running %@ '%@'", self.class, NSStringFromSelector(_cmd));
    }
    UITableView *tableView = self.tableView;
    switch(type) {
        case NSFetchedResultsChangeInsert:
            [tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:newIndexPath]
             withRowAnimation:UITableViewRowAnimationAutomatic];
            break;
        case NSFetchedResultsChangeDelete:
            [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath]
                             withRowAnimation:UITableViewRowAnimationAutomatic];
            break;
        case NSFetchedResultsChangeUpdate:
            if (!newIndexPath) {
                [tableView reloadRowsAtIndexPaths:[NSArray arrayWithObject:indexPath]
                     withRowAnimation:UITableViewRowAnimationNone];
            } else {
                [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath]
                     withRowAnimation:UITableViewRowAnimationNone];
                [tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:newIndexPath]
                     withRowAnimation:UITableViewRowAnimationNone];
            }
            break;
        case NSFetchedResultsChangeMove:
            [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath]
              withRowAnimation:UITableViewRowAnimationAutomatic];
            [tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:newIndexPath]
             withRowAnimation:UITableViewRowAnimationAutomatic];
            break;
    }
}


@end
