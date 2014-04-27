//
//  AGCOwnerTableViewController.m
//  Risk Mgmt
//
//  Created by Alessandro on 06/04/14.
//  Copyright (c) 2014 Alessandro Galletto. All rights reserved.
//

#import "AGCOwnerTableViewController.h"
#import "AGCOwnerTableViewCell.h"
#import "AGCOwnerViewController.h"
#import "AGCGlobalVariables.h"
#import "CoreDataHelper.h"
#import "Deduplicator.h"
#import "Thumbnailer.h"
#import "AGCAppDelegate.h"
#import "Owner.h"
#import "Risk_group.h"


@implementation AGCOwnerTableViewController
#define debug 1

@synthesize delegate;

#pragma mark - DATA
- (void)configureFetch {
    if (debug==1) {
        NSLog(@"Running %@ '%@'", self.class, NSStringFromSelector(_cmd));
    }
    CoreDataHelper *base_de_datos =[CoreDataHelper sharedHelper];
    
    NSFetchRequest *request =
    [NSFetchRequest fetchRequestWithEntityName:@"Owner"];
    
    request.sortDescriptors =
    [NSArray arrayWithObjects:
         [NSSortDescriptor sortDescriptorWithKey:@"surname" ascending:YES],
         [NSSortDescriptor sortDescriptorWithKey:@"name" ascending:YES], nil];
    [request setFetchBatchSize:20];
    
    self.frc =
    [[NSFetchedResultsController alloc] initWithFetchRequest:request
         managedObjectContext:base_de_datos.context
         sectionNameKeyPath:@"surname"
         cacheName:nil];
    self.frc.delegate = self;
}

#pragma mark - VIEW
-(void) viewDidAppear:(BOOL)animated {
    if (debug==1) {
        NSLog(@"Running %@ '%@'", self.class, NSStringFromSelector(_cmd));
    }
    [super viewDidAppear:animated];
    
    // Create missing Thumbnails
    CoreDataHelper *base_de_datos =
    [(AGCAppDelegate *)[[UIApplication sharedApplication] delegate] base_de_datos];
    NSArray *sortDescriptors = [NSArray arrayWithObjects:
                                [NSSortDescriptor sortDescriptorWithKey:@"surname"
                                                              ascending:YES],
                                [NSSortDescriptor sortDescriptorWithKey:@"name"
                                                              ascending:YES],
                                nil];
    
    [Thumbnailer createMissingThumbnailsForEntityName:@"Owner"
                           withThumbnailAttributeName:@"thumbnail"
                            withPhotoRelationshipName:@"photo"
                               withPhotoAttributeName:@"data"
                                  withSortDescriptors:sortDescriptors
                                    withImportContext:base_de_datos.importContext];
    
    [base_de_datos.context performBlock:^{
    CoreDataHelper *base_de_datos = [CoreDataHelper sharedHelper];
    [Deduplicator deDuplicateEntityWithName:@"Owner"
                    withUniqueAttributeName:@"id"
                          withImportContext:base_de_datos.importContext];
    }];
}

- (void)viewDidLoad {
    if (debug==1) {
        NSLog(@"Running %@ '%@'", self.class, NSStringFromSelector(_cmd));
        }
    [super viewDidLoad];
    
    [self configureFetch];
    [self performFetch];
    self.deleteConfirmActionSheet.delegate = self;
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self
        selector:@selector(performFetch)
        name:@"SomethingChanged"
        object:nil];
    
    [self configureSearch];
    
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (debug==1) {
        NSLog(@"Running %@ '%@'", self.class, NSStringFromSelector(_cmd));
    }
    
    static NSString *cellIdentifier = @"OwnerCell";
    
    AGCOwnerTableViewCell *cell =
    [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if (cell == nil) {
        cell = [[AGCOwnerTableViewCell alloc] initWithStyle:UITableViewCellStyleValue1
                                      reuseIdentifier:cellIdentifier];
    }
    
    Owner *owner = [[self frcFromTV:tableView] objectAtIndexPath:indexPath];
    
    if(tableView == self.searchDisplayController.searchResultsTableView){
        cell.textLabel.text=owner.surname;
    }
    else
    {
    cell.ownernamelbl.text=owner.name;
    cell.ownersurnamelbl.text=owner.surname;
    cell.owneremaillbl.text=owner.email;
    cell.ownerimagelbl.image = [UIImage imageWithData:owner.thumbnail];
    }
    
    return cell;

}

- (NSArray*)sectionIndexTitlesForTableView:(UITableView *)tableView {
    if (debug==1) {
        NSLog(@"Running %@ '%@'", self.class, NSStringFromSelector(_cmd));
    }
    return nil; // we don't want a section index.
}


- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (debug==1) {
        NSLog(@"Running %@ '%@'", self.class, NSStringFromSelector(_cmd));
    }
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        //AGC pedir confirmacion del borrado
        self.deleteindexPath=indexPath;
        self.deleteConfirmActionSheet=
                [[UIActionSheet alloc] initWithTitle:@"Delete Owner. Are you really sure?"
                                            delegate:self
                                   cancelButtonTitle:@"Cancel"
                              destructiveButtonTitle:@"Delete"
                                   otherButtonTitles:nil, nil];
        [self.deleteConfirmActionSheet showFromTabBar:self.navigationController.tabBarController.tabBar];
    }
    CoreDataHelper *cdh = [CoreDataHelper sharedHelper];
    [cdh backgroundSaveContext];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (debug==1) {
        NSLog(@"Running %@ '%@'", self.class, NSStringFromSelector(_cmd));
    }
    
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    cell.contentView.backgroundColor = [UIColor colorWithRed:0.1 green:1.0 blue:0.1 alpha:1.0];

    CoreDataHelper *cdh = [CoreDataHelper sharedHelper];
    [cdh backgroundSaveContext];
    

    if (self.delegate) {
        [self.delegate selectedOwner:[[self.frc objectAtIndexPath:indexPath] objectID]];
        if(self.searchDisplayController.searchResultsTableView==tableView)
            [self.delegate selectedOwner:[[self.searchFRC objectAtIndexPath:indexPath] objectID]];
        else
            [self.delegate selectedOwner:[[self.frc objectAtIndexPath:indexPath] objectID]];
    }
    
    
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    if (debug==1) {
        NSLog(@"Running %@ '%@'", self.class, NSStringFromSelector(_cmd));
    }
}

#pragma mark - Segue

- (void)tableView:(UITableView *)tableView
                    accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath {
    if (debug==1) {
        NSLog(@"Running %@ '%@'", self.class, NSStringFromSelector(_cmd));
    }
    
    AGCOwnerViewController *ownerviewcontroller =
                [self.storyboard instantiateViewControllerWithIdentifier:@"OwnerViewController"];
    
        if(self.searchDisplayController.searchResultsTableView==tableView)
                ownerviewcontroller.selectedOwnerID =
                                                [[self.searchFRC objectAtIndexPath:indexPath] objectID];
        else
                ownerviewcontroller.selectedOwnerID =
                                                [[self.frc objectAtIndexPath:indexPath] objectID];
    
    ownerviewcontroller.newOwner=FALSE;
    [self.navigationController pushViewController:ownerviewcontroller animated:YES];
}

#pragma mark - INTERACTION

-(void) actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (debug==1) {
        NSLog(@"Running %@ '%@'", self.class, NSStringFromSelector(_cmd));
    }
    if (actionSheet==self.deleteConfirmActionSheet){
        if (buttonIndex==[actionSheet destructiveButtonIndex]){
            [self deleteOwner];
        }
        else{
            if (buttonIndex==[actionSheet cancelButtonIndex]){
                [actionSheet dismissWithClickedButtonIndex:[actionSheet cancelButtonIndex]
                                                  animated:YES];
            }
        }
        
        }
    }


-(void) deleteOwner {
    if (debug==1) {
        NSLog(@"Running %@ '%@'", self.class, NSStringFromSelector(_cmd));
    }
    Owner *deleteTarget = [self.frc objectAtIndexPath:self.deleteindexPath];
    [self.frc.managedObjectContext deleteObject:deleteTarget];
    [self.tableView reloadRowsAtIndexPaths:[NSArray arrayWithObject:self.deleteindexPath]
                          withRowAnimation:UITableViewRowAnimationFade];
}
- (IBAction)newOwner:(UIBarButtonItem *)sender {
    if (debug==1) {
        NSLog(@"Running %@ '%@'", self.class, NSStringFromSelector(_cmd));
    }
    CoreDataHelper *base_de_datos =[CoreDataHelper sharedHelper];
    Owner *newOwner =
    [NSEntityDescription insertNewObjectForEntityForName:@"Owner"
                                  inManagedObjectContext:base_de_datos.context];
    NSUUID *uuid=[[NSUUID alloc] init];
    NSString *key=[uuid UUIDString];
    newOwner.id=key;
    newOwner.updated_at=[NSDate date];
    newOwner.name=@"NewOwner";
    NSError *error = nil;
    if (![base_de_datos.context
          obtainPermanentIDsForObjects:[NSArray arrayWithObject:newOwner]
          error:&error]) {
        NSLog(@"Couldn't obtain a permanent ID for object %@", error);
    }
    AGCGlobalVariables *globalVariables = [AGCGlobalVariables sharedManager];
    // AGC hay que poner bien la relación dependiendo de risk_group
    //   newOwner.risk_group=(Risk_group *)globalVariables.selectedRiskGroupID;
    
    // select and refresh the detail view
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:1 inSection:0];
    [self.tableView selectRowAtIndexPath:indexPath animated:YES scrollPosition:UITableViewScrollPositionNone];
    [self tableView:self.tableView didSelectRowAtIndexPath:indexPath];
    
}

// toggle edit mode
- (IBAction)toggleEditingMode:(id)sender {
    if (debug==1) {
        NSLog(@"Running %@ '%@'", self.class, NSStringFromSelector(_cmd));
    }
    if (self.isEditing){
        ((UIBarButtonItem*)sender).title=@"Edit";
        [self setEditing:NO animated:YES];
    }
    else {
        ((UIBarButtonItem*)sender).title=@"Done";
        [self setEditing:YES animated:YES];
    }
}
//reordering rows

-(void) tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)sourceIndexPath toIndexPath:(NSIndexPath *)destinationIndexPath{
    // pag 444 del bnr
}

#pragma mark - SEARCH
- (BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchString:(NSString *)searchString {
    if (debug==1) {
        NSLog(@"Running %@ '%@'", self.class, NSStringFromSelector(_cmd));
    }
    if (searchString.length > 0) {
        NSLog(@"--> Searching for '%@'", searchString);
        NSPredicate *predicate =
        [NSPredicate predicateWithFormat:@"name CONTAINS[cd] %@ OR surname CONTAINS[cd] %@ OR email CONTAINS[cd] %@", searchString, searchString, searchString];
        
        NSArray *sortDescriptors =
        [NSArray arrayWithObjects:
         [NSSortDescriptor sortDescriptorWithKey:@"surname"
                                       ascending:YES],
         [NSSortDescriptor sortDescriptorWithKey:@"name"
                                       ascending:YES], nil];
        
        CoreDataHelper *base_de_datos =
        [(AGCAppDelegate *)[[UIApplication sharedApplication] delegate] base_de_datos];
        
        [self reloadSearchFRCForPredicate:predicate
                               withEntity:@"Owner"
                                inContext:base_de_datos.context
                      withSortDescriptors:sortDescriptors
                   withSectionNameKeyPath:@"surname"];
    } else {
        return NO;
    }
    return YES;
}
# pragma mark - Header of table view customization
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (debug==1) {
        NSLog(@"Running %@ '%@'", self.class, NSStringFromSelector(_cmd));
    }
    
    float width = tableView.bounds.size.width;
    int fontSize = 12;
    int padding = 50;
    
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, width, fontSize)];
    view.backgroundColor = [UIColor colorWithWhite:0 alpha:0];
    view.userInteractionEnabled = YES;
    view.tag = section;
    
    UIImageView *image = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"the-boss.png"]];
    CGRect myFrame = image.frame;
    myFrame.origin.x = 10;
    myFrame.origin.y = 1;
    image.frame=myFrame;
    image.contentMode = UIViewContentModeScaleAspectFit;
    
    [view addSubview:image];
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(padding, 2, width - padding, fontSize)];
    
    myFrame = label.frame;
    myFrame.origin.x = 50;
    myFrame.origin.y = 8;
    label.frame=myFrame;
    
    if(self.searchDisplayController.searchResultsTableView==tableView)
        return nil;
    else{
        NSIndexPath *path = [NSIndexPath indexPathForRow:0 inSection:section];
        
            NSManagedObjectID *objectID= [[self.frc objectAtIndexPath:path] objectID];
            
            CoreDataHelper *base_de_datos = [CoreDataHelper sharedHelper];
            
            
            Owner *owner = (Owner*)[base_de_datos.context existingObjectWithID:objectID
                                                                                        error:nil];
            label.text = owner.surname;
    }
    
    label.backgroundColor = [UIColor clearColor];
    label.textColor = [UIColor redColor];
    label.shadowOffset = CGSizeMake(0,1);
    label.font = [UIFont boldSystemFontOfSize:fontSize];
    
    [view addSubview:label];
    
    return view;
}




@end
