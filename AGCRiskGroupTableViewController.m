//
//  AGCRiskGroupTableViewController.m
//  Risk Mgmt
//
//  Created by Alessandro on 06/04/14.
//  Copyright (c) 2014 Alessandro Galletto. All rights reserved.
//

#import "AGCRiskGroupTableViewController.h"
#import "AGCRiskGroupTableViewCell.h"
#import "AGCRiskGroupViewController.h"
#import "AGCGlobalVariables.h"
#import "CoreDataHelper.h"
#import "Deduplicator.h"
#import "Thumbnailer.h"
#import "AGCAppDelegate.h"
#import "Risk_group.h"

@implementation AGCRiskGroupTableViewController


#define debug 1

#pragma mark - DATA
- (void)configureFetch {
    if (debug==1) {
        NSLog(@"Running %@ '%@'", self.class, NSStringFromSelector(_cmd));
    }
    CoreDataHelper *base_de_datos =[CoreDataHelper sharedHelper];
    
    NSFetchRequest *request =
    [NSFetchRequest fetchRequestWithEntityName:@"Risk_group"];
    
    request.sortDescriptors =
    [NSArray arrayWithObjects:
         [NSSortDescriptor sortDescriptorWithKey:@"code" ascending:YES],
         [NSSortDescriptor sortDescriptorWithKey:@"short_name" ascending:YES], nil];
    [request setFetchBatchSize:20];
    
    self.frc =
    [[NSFetchedResultsController alloc] initWithFetchRequest:request
         managedObjectContext:base_de_datos.context
         sectionNameKeyPath:@"code"
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
                                [NSSortDescriptor sortDescriptorWithKey:@"code"
                                                              ascending:YES],
                                [NSSortDescriptor sortDescriptorWithKey:@"short_name"
                                                              ascending:YES],
                                nil];
    
    [Thumbnailer createMissingThumbnailsForEntityName:@"Risk_group"
                           withThumbnailAttributeName:@"thumbnail"
                            withPhotoRelationshipName:@"photo"
                               withPhotoAttributeName:@"data"
                                  withSortDescriptors:sortDescriptors
                                    withImportContext:base_de_datos.importContext];
    
    [base_de_datos.context performBlock:^{
    CoreDataHelper *base_de_datos = [CoreDataHelper sharedHelper];
    [Deduplicator deDuplicateEntityWithName:@"Risk_group"
                    withUniqueAttributeName:@"id"
                          withImportContext:base_de_datos.importContext];
    }];
    
    // Selected cell goes green
    if (self.selectedindexPath!=nil){
        UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:self.selectedindexPath];
        cell.contentView.backgroundColor = [UIColor colorWithRed:0.8 green:1.0 blue:0.93 alpha:1.0];
    }
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
    
    static NSString *cellIdentifier = @"RiskGroupCell";
    
    AGCRiskGroupTableViewCell *cell =
    [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if (cell == nil) {
        cell = [[AGCRiskGroupTableViewCell alloc] initWithStyle:UITableViewCellStyleValue1
                                      reuseIdentifier:cellIdentifier];
    }
    
    cell.accessoryType = UITableViewCellAccessoryDetailButton;
    Risk_group *risk_group = [[self frcFromTV:tableView] objectAtIndexPath:indexPath];
    
    if(tableView == self.searchDisplayController.searchResultsTableView){
        cell.textLabel.text=risk_group.short_name;
    }
    else
    {
    cell.riskgroupcodelbl.text=risk_group.code;
    cell.riskgroupnamelbl.text=risk_group.short_name;
    cell.riskgroupdesclbl.text=risk_group.desc;
    cell.riskgroupimagelbl.image = [UIImage imageWithData:risk_group.thumbnail];
        
    //set background color for selected row
    if (self.selectedindexPath==nil) self.selectedindexPath=indexPath;
    if ([indexPath compare:self.selectedindexPath]==NSOrderedSame)
        cell.contentView.backgroundColor = [UIColor colorWithRed:0.8 green:1.0 blue:0.93 alpha:1.0];
    else
        cell.contentView.backgroundColor = [UIColor colorWithWhite:1.0 alpha:1.0];
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
        // AGC pedir confirmacion del borrado
        self.deleteindexPath=indexPath;
        self.deleteConfirmActionSheet=
                [[UIActionSheet alloc] initWithTitle:@"Delete entire Risk Group and all its dependent information: assets, risks... Are you really sure?"
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
    
    if(tableView != self.searchDisplayController.searchResultsTableView){
        
        // Previous selected cell goes white
        UITableViewCell *cell = [tableView cellForRowAtIndexPath:self.selectedindexPath];
        cell.contentView.backgroundColor = [UIColor colorWithWhite:1.0 alpha:1.0];
    
        // Selected row goes green
        cell = [tableView cellForRowAtIndexPath:indexPath];
        cell.contentView.backgroundColor = [UIColor colorWithRed:0.8 green:1.0 blue:0.93 alpha:1.0];
    
        // New selected cell
        self.selectedindexPath=indexPath;
    }
    
    Risk_group *riskGroup;
    if(self.searchDisplayController.searchResultsTableView==tableView){
        self.selectedindexPath=indexPath;
        AGCGlobalVariables *globalVariables = [AGCGlobalVariables sharedManager];
        riskGroup=((Risk_group *)[self.searchFRC objectAtIndexPath:indexPath]);
        globalVariables.selectedRiskGroupID=riskGroup.objectID;
        globalVariables.selectedRiskGroupUUID= riskGroup.id;
        globalVariables.selectedRiskGroupCode = riskGroup.code;
        globalVariables.selectedRiskGroupTitle = [NSString stringWithFormat:@"%@ - %@", riskGroup.code ,riskGroup.short_name];
        
    }else{
        self.selectedindexPath=indexPath;
        AGCGlobalVariables *globalVariables = [AGCGlobalVariables sharedManager];
        riskGroup=((Risk_group *)[self.frc objectAtIndexPath:indexPath]);
        globalVariables.selectedRiskGroupID=riskGroup.objectID;
        globalVariables.selectedRiskGroupUUID= riskGroup.id;
        globalVariables.selectedRiskGroupCode = riskGroup.code;
        globalVariables.selectedRiskGroupTitle = [NSString stringWithFormat:@"%@ - %@", riskGroup.code ,riskGroup.short_name];
    }
    
    CoreDataHelper *cdh = [CoreDataHelper sharedHelper];
    [cdh backgroundSaveContext];
    
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

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if (debug==1) {
        NSLog(@"Running %@ '%@'", self.class, NSStringFromSelector(_cmd));
    }
    AGCRiskGroupViewController *riskgroupviewcontroller = segue.destinationViewController;
    if ([segue.identifier isEqualToString:@"RiskGroupViewControllerSegue"])
        {
            CoreDataHelper *base_de_datos =[CoreDataHelper sharedHelper];
            Risk_group *newRisk_group =
            [NSEntityDescription insertNewObjectForEntityForName:@"Risk_group"
                     inManagedObjectContext:base_de_datos.context];
            NSUUID *uuid=[[NSUUID alloc] init];
            NSString *key=[uuid UUIDString];
            newRisk_group.id=key;
            newRisk_group.created_at=[NSDate date];
            newRisk_group.updated_at=[NSDate date];
            newRisk_group.code=@"NewRiskGroup";
            
            NSError *error = nil;
            if (![base_de_datos.context
                          obtainPermanentIDsForObjects:[NSArray arrayWithObject:newRisk_group]
                          error:&error]) {
                NSLog(@"Couldn't obtain a permanent ID for object %@", error);
                }
            riskgroupviewcontroller.selectedRiskGroupID = newRisk_group.objectID;
            AGCGlobalVariables *globalVariables = [AGCGlobalVariables sharedManager];
            globalVariables.selectedRiskGroupID=newRisk_group.objectID;
            globalVariables.selectedRiskGroupUUID=key;
            globalVariables.selectedRiskGroupCode = newRisk_group.code;
            globalVariables.selectedRiskGroupTitle = [NSString stringWithFormat:@"%@ - %@", newRisk_group.code, newRisk_group.short_name];
            riskgroupviewcontroller.newRiskGroup=YES;
            }
    else {
        NSLog(@"Unidentified Segue Attempted!");
        }
}

- (void)tableView:(UITableView *)tableView
                    accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath {
    if (debug==1) {
        NSLog(@"Running %@ '%@'", self.class, NSStringFromSelector(_cmd));
    }
    
    UITableViewCell *cell;
    
    if(tableView != self.searchDisplayController.searchResultsTableView){
        // Previous selected cell goes white
        if(self.selectedindexPath!=nil){
            cell = [tableView cellForRowAtIndexPath:self.selectedindexPath];
            cell.contentView.backgroundColor = [UIColor colorWithWhite:1.0 alpha:1.0];
            }
        // Selected row goes green
        cell = [tableView cellForRowAtIndexPath:indexPath];
        cell.contentView.backgroundColor = [UIColor colorWithRed:0.8 green:1.0 blue:0.93 alpha:1.0];
    
        // New selected cell
        self.selectedindexPath=indexPath;
        
    }
    
    AGCRiskGroupViewController *riskgroupviewcontroller =
                [self.storyboard instantiateViewControllerWithIdentifier:@"RiskGroupViewController"];
    
    Risk_group *riskGroup;
    if(self.searchDisplayController.searchResultsTableView==tableView){
                riskgroupviewcontroller.selectedRiskGroupID =
                                                [[self.searchFRC objectAtIndexPath:indexPath] objectID];
                AGCGlobalVariables *globalVariables = [AGCGlobalVariables sharedManager];
                globalVariables.selectedRiskGroupID=riskgroupviewcontroller.selectedRiskGroupID;
                riskGroup=((Risk_group *)[self.searchFRC objectAtIndexPath:indexPath]);
                globalVariables.selectedRiskGroupUUID= riskGroup.id;
                globalVariables.selectedRiskGroupCode = riskGroup.code;
                globalVariables.selectedRiskGroupTitle = [NSString stringWithFormat:@"%@ - %@", riskGroup.code ,riskGroup.short_name];
        
    }else{
                riskgroupviewcontroller.selectedRiskGroupID =
                                                [[self.frc objectAtIndexPath:indexPath] objectID];
                AGCGlobalVariables *globalVariables = [AGCGlobalVariables sharedManager];
                globalVariables.selectedRiskGroupID=riskgroupviewcontroller.selectedRiskGroupID;
                riskGroup=((Risk_group *)[self.frc objectAtIndexPath:indexPath]);
                globalVariables.selectedRiskGroupUUID= riskGroup.id;
                globalVariables.selectedRiskGroupCode = riskGroup.code;
                globalVariables.selectedRiskGroupTitle = [NSString stringWithFormat:@"%@ - %@", riskGroup.code ,riskGroup.short_name];
    }
    riskgroupviewcontroller.newRiskGroup=FALSE;
    [self.navigationController pushViewController:riskgroupviewcontroller animated:YES];
}

#pragma mark - INTERACTION

-(void) actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (actionSheet==self.deleteConfirmActionSheet){
        if (buttonIndex==[actionSheet destructiveButtonIndex]){
            [self deleteRiskGroup];
        }
        else{
            if (buttonIndex==[actionSheet cancelButtonIndex]){
                [actionSheet dismissWithClickedButtonIndex:[actionSheet cancelButtonIndex]
                                                  animated:YES];
            }
        }
        
        }
    }


-(void) deleteRiskGroup {
    self.selectedindexPath=nil;
    Risk_group *deleteTarget = [self.frc objectAtIndexPath:self.deleteindexPath];
    [self.frc.managedObjectContext deleteObject:deleteTarget];
    [self.tableView reloadRowsAtIndexPaths:[NSArray arrayWithObject:self.deleteindexPath]
                          withRowAnimation:UITableViewRowAnimationFade];
}

// toggle edit mode
- (IBAction)toggleEditingMode:(id)sender {
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
        [NSPredicate predicateWithFormat:@"code CONTAINS[cd] %@ OR short_name CONTAINS[cd] %@ OR desc CONTAINS[cd] %@", searchString, searchString, searchString];
        
        NSArray *sortDescriptors =
        [NSArray arrayWithObjects:
         [NSSortDescriptor sortDescriptorWithKey:@"code"
                                       ascending:YES],
         [NSSortDescriptor sortDescriptorWithKey:@"short_name"
                                       ascending:YES], nil];
        
        CoreDataHelper *base_de_datos =
        [(AGCAppDelegate *)[[UIApplication sharedApplication] delegate] base_de_datos];
        
        [self reloadSearchFRCForPredicate:predicate
                               withEntity:@"Risk_group"
                                inContext:base_de_datos.context
                      withSortDescriptors:sortDescriptors
                   withSectionNameKeyPath:@"code"];
    } else {
        return NO;
    }
    return YES;
}
# pragma mark - Header of table view customization
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    float width = tableView.bounds.size.width;
    int fontSize = 18;
    int padding = 50;
    
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, width, fontSize)];
    view.backgroundColor = [UIColor colorWithWhite:0 alpha:0];
    view.userInteractionEnabled = YES;
    view.tag = section;
    
    UIImageView *image = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Icon #1 29 Rounded.png"]];
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
            
            
            Risk_group *risk_group = (Risk_group*)[base_de_datos.context existingObjectWithID:objectID
                                                                                        error:nil];
            label.text = risk_group.code;
    }
    
    label.backgroundColor = [UIColor clearColor];
    label.textColor = [UIColor redColor];
    label.shadowOffset = CGSizeMake(0,1);
    label.font = [UIFont boldSystemFontOfSize:fontSize];
    
    [view addSubview:label];
    
    return view;
}
@end
