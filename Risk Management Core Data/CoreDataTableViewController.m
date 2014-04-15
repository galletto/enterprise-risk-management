//
//  CoreDataTableViewController.m
//  v2.0
//
//  Created by Tim Roadley on 09/09/13.
//  Copyright (c) 2013 Tim Roadley. All rights reserved.
//
//  This class is free to use in production applications for owners of "Learning Core Data for iOS" by Tim Roadley
//

#import "CoreDataTableViewController.h"
@implementation CoreDataTableViewController
#define debug 0

#pragma mark - FETCHING
- (void)performFetch {
    if (debug==1) {
        NSLog(@"Running %@ '%@'", self.class, NSStringFromSelector(_cmd));
    }
    
    if (self.frc) {
        [self.frc.managedObjectContext performBlockAndWait:^{
            
            NSError *error = nil;
            if (![self.frc performFetch:&error]) {
                
                NSLog(@"Failed to perform fetch: %@", error);
            }
            [self.tableView reloadData];
        }];
    } else {
        NSLog(@"Failed to fetch, the fetched results controller is nil.");
    }
}

#pragma mark - DATASOURCE: UITableView
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (debug==1) {
        NSLog(@"Running %@ '%@'", self.class, NSStringFromSelector(_cmd));
    }
    return [[[[self frcFromTV:tableView]sections] objectAtIndex:section] numberOfObjects];
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    if (debug==1) {
        NSLog(@"Running %@ '%@'", self.class, NSStringFromSelector(_cmd));
    }
    return [[[self frcFromTV:tableView] sections] count];
}
- (NSInteger)tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)index {
    if (debug==1) {
        NSLog(@"Running %@ '%@'", self.class, NSStringFromSelector(_cmd));
    }
    return [[self frcFromTV:tableView] sectionForSectionIndexTitle:title atIndex:index];
}
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    if (debug==1) {
        NSLog(@"Running %@ '%@'", self.class, NSStringFromSelector(_cmd));
    }
    return [[[[self frcFromTV:tableView] sections] objectAtIndex:section] name];
}
- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView {
    if (debug==1) {
        NSLog(@"Running %@ '%@'", self.class, NSStringFromSelector(_cmd));
    }
    return [[self frcFromTV:tableView] sectionIndexTitles];
}

#pragma mark - DELEGATE: NSFetchedResultsController
- (void)controllerWillChangeContent:(NSFetchedResultsController *)controller {
    if (debug==1) {
        NSLog(@"Running %@ '%@'", self.class, NSStringFromSelector(_cmd));
    }
    [[self TVFromFRC:controller] beginUpdates];
}
- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller {
    if (debug==1) {
        NSLog(@"Running %@ '%@'", self.class, NSStringFromSelector(_cmd));
    }
    [[self TVFromFRC:controller] endUpdates];
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
            [[self TVFromFRC:controller] insertSections:[NSIndexSet indexSetWithIndex:sectionIndex]
                                       withRowAnimation:UITableViewRowAnimationFade];
            break;
            
        case NSFetchedResultsChangeDelete:
            [[self TVFromFRC:controller] deleteSections:[NSIndexSet indexSetWithIndex:sectionIndex]
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
    switch(type) {
            
        case NSFetchedResultsChangeInsert:
            [[self TVFromFRC:controller] insertRowsAtIndexPaths:[NSArray arrayWithObject:newIndexPath]
                                               withRowAnimation:UITableViewRowAnimationAutomatic];
            break;
            
        case NSFetchedResultsChangeDelete:
            [[self TVFromFRC:controller] deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath]
                                               withRowAnimation:UITableViewRowAnimationAutomatic];
            break;
            
        case NSFetchedResultsChangeUpdate:
            if (!newIndexPath) {
                [[self TVFromFRC:controller] reloadRowsAtIndexPaths:[NSArray arrayWithObject:indexPath]
                                                   withRowAnimation:UITableViewRowAnimationNone];
            }
            else {
                [[self TVFromFRC:controller] deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath]
                                                   withRowAnimation:UITableViewRowAnimationNone];
                [[self TVFromFRC:controller] insertRowsAtIndexPaths:[NSArray arrayWithObject:newIndexPath]
                                                   withRowAnimation:UITableViewRowAnimationNone];
            }
            break;
            
        case NSFetchedResultsChangeMove:
            [[self TVFromFRC:controller] deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath]
                                               withRowAnimation:UITableViewRowAnimationAutomatic];
            [[self TVFromFRC:controller] insertRowsAtIndexPaths:[NSArray arrayWithObject:newIndexPath]
                                               withRowAnimation:UITableViewRowAnimationAutomatic];
            break;
    }
}

#pragma mark - GENERAL
- (NSFetchedResultsController*)frcFromTV:(UITableView*)tableView {
    /*
     If the given tableView is self.tableview return self.frc,
     otherwise self.searchFRC
     */
    return (tableView == self.tableView) ? self.frc : self.searchFRC;
}
- (UITableView*)TVFromFRC:(NSFetchedResultsController*)frc {
    /*
     If the given fetched results controller is self.frc return self.tableView,
     otherwise self.searchDC.searchResultsTableView
     */
    return (frc == self.frc) ? self.tableView : self.searchDC.searchResultsTableView;
}

#pragma mark - DELEGATE: UISearchDisplayController
- (void)searchDisplayControllerDidEndSearch:(UISearchDisplayController *)controller {
    if (debug==1) {
        NSLog(@"Running %@ '%@'", self.class, NSStringFromSelector(_cmd));
    }
    self.searchFRC.delegate = nil;
    self.searchFRC = nil;
}

#pragma mark - SEARCH
- (void)reloadSearchFRCForPredicate:(NSPredicate*)predicate
                         withEntity:(NSString*)entity
                          inContext:(NSManagedObjectContext*)context
                withSortDescriptors:(NSArray*)sortDescriptors
             withSectionNameKeyPath:(NSString*)sectionNameKeyPath {
    if (debug==1) {
        NSLog(@"Running %@ '%@'", self.class, NSStringFromSelector(_cmd));
    }
    NSFetchRequest *request = [[NSFetchRequest alloc] initWithEntityName:entity];
    request.sortDescriptors = sortDescriptors;
    request.predicate = predicate;
    request.fetchBatchSize = 15;
    
    self.searchFRC =
    [[NSFetchedResultsController alloc] initWithFetchRequest:request
                                        managedObjectContext:context
                                          sectionNameKeyPath:sectionNameKeyPath
                                                   cacheName:nil];
    self.searchFRC.delegate = self;
    
    [self.searchFRC.managedObjectContext performBlockAndWait:^{
        NSError *error;
        if (![self.searchFRC performFetch:&error]) {
            NSLog(@"SEARCH FETCH ERROR: %@", error);
        }
    }];
}
- (void)configureSearch {
    if (debug==1) {
        NSLog(@"Running %@ '%@'", self.class, NSStringFromSelector(_cmd));
    }
    UISearchBar *searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0, 0, self.tableView.frame.size.width, 44.0)];
    searchBar.autocorrectionType = UITextAutocorrectionTypeNo;
    self.tableView.tableHeaderView = searchBar;
    
    self.searchDC = [[UISearchDisplayController alloc] initWithSearchBar:searchBar
                                                      contentsController:self];
    self.searchDC.delegate = self;
    self.searchDC.searchResultsDataSource = self;
    self.searchDC.searchResultsDelegate = self;
}

@end
