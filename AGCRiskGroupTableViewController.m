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
#import "AGCCoreDataHelper.h"
#import "AGCAppDelegate.h"
#import "Risk_group.h"

@interface AGCRiskGroupTableViewController ()

@end

@implementation AGCRiskGroupTableViewController


#define debug 0

#pragma mark - DATA
- (void)configureFetch {
    if (debug==1) {
        NSLog(@"Running %@ '%@'", self.class, NSStringFromSelector(_cmd));
    }
    AGCCoreDataHelper *cdh =
    [(AGCAppDelegate *)[[UIApplication sharedApplication] delegate] base_de_datos];
    
    NSFetchRequest *request =
    [NSFetchRequest fetchRequestWithEntityName:@"Risk_group"];
    
    request.sortDescriptors =
    [NSArray arrayWithObjects:
         [NSSortDescriptor sortDescriptorWithKey:@"code" ascending:YES],
         [NSSortDescriptor sortDescriptorWithKey:@"short_name" ascending:YES], nil];
    [request setFetchBatchSize:50];
    self.fetchedresultscontroller =
    [[NSFetchedResultsController alloc] initWithFetchRequest:request
         managedObjectContext:cdh.context
         sectionNameKeyPath:@"code"
         cacheName:nil];
    self.fetchedresultscontroller.delegate = self;
}

#pragma mark - VIEW
- (void)viewDidLoad {
    if (debug==1) {
        NSLog(@"Running %@ '%@'", self.class, NSStringFromSelector(_cmd));
        }
    [super viewDidLoad];
    [self configureFetch];
    [self performFetch];
    self.clearConfirmActionSheet.delegate = self;
    
    [[NSNotificationCenter defaultCenter] addObserver:self
        selector:@selector(performFetch)
        name:@"SomethingChanged"
        object:nil];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (debug==1) {
        NSLog(@"Running %@ '%@'", self.class, NSStringFromSelector(_cmd));
    }
    static NSString *cellIdentifier = @"RiskGroupCell";
    AGCRiskGroupTableViewCell *cell =[tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
    cell.accessoryType = UITableViewCellAccessoryDetailButton;
    Risk_group *risk_group = [self.fetchedresultscontroller objectAtIndexPath:indexPath];
    
    NSMutableString *title = [NSMutableString stringWithFormat:@"%@%@ %@", risk_group.code, risk_group.short_name, risk_group.desc];
    [title replaceOccurrencesOfString:@"(null)"
         withString:@""
         options:0
         range:NSMakeRange(0, [title length])];
    
    cell.riskgroupcodelbl.text=risk_group.code;
    cell.riskgroupnamelbl.text=risk_group.short_name;
    cell.riskgroupdesclbl.text=risk_group.desc;
    cell.riskgroupdesclbl.text=@"comentario de descripcion largo. Lorem ipsum dolor sit amet, consectetur adipisicing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.";
 
    cell.riskgroupimagelbl.image=[UIImage imageNamed:@"riskgroupicon.png"];
    
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
        Risk_group *deleteTarget = [self.fetchedresultscontroller objectAtIndexPath:indexPath];
        [self.fetchedresultscontroller.managedObjectContext deleteObject:deleteTarget];
        [self.tableView reloadRowsAtIndexPaths:[NSArray arrayWithObject:indexPath]
          withRowAnimation:UITableViewRowAnimationFade];
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (debug==1) {
        NSLog(@"Running %@ '%@'", self.class, NSStringFromSelector(_cmd));
    }
    NSManagedObjectID *itemid =
    [[self.fetchedresultscontroller objectAtIndexPath:indexPath] objectID];
    
    Risk_group *item =
    (Risk_group *)[self.fetchedresultscontroller.managedObjectContext existingObjectWithID:itemid
            error:nil];
    item=nil;
    
    [self.tableView reloadRowsAtIndexPaths:[NSArray arrayWithObject:indexPath]
     withRowAnimation:UITableViewRowAnimationNone];
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
}

#pragma mark - Segue

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if (debug==1) {
        NSLog(@"Running %@ '%@'", self.class, NSStringFromSelector(_cmd));
    }
    AGCRiskGroupViewController *riskgroupviewcontroller = segue.destinationViewController;
    if ([segue.identifier isEqualToString:@"Anadir grupo riesgo segue"])
        {
            AGCCoreDataHelper *base_de_datos =
            [(AGCAppDelegate *)[[UIApplication sharedApplication] delegate] base_de_datos];
            Risk_group *newRisk_group =
            [NSEntityDescription insertNewObjectForEntityForName:@"Risk_group"
                     inManagedObjectContext:base_de_datos.context];
            NSError *error = nil;
            if (![base_de_datos.context
                          obtainPermanentIDsForObjects:[NSArray arrayWithObject:newRisk_group]
                          error:&error]) {
                NSLog(@"Couldn't obtain a permanent ID for object %@", error);
                }
            riskgroupviewcontroller.selectedRiskGroupID = newRisk_group.objectID;
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
    AGCRiskGroupViewController *riskgroupviewcontroller =
    [self.storyboard instantiateViewControllerWithIdentifier:@"RiskGroupViewController"];
    riskgroupviewcontroller.selectedRiskGroupID =
    [[self.fetchedresultscontroller objectAtIndexPath:indexPath] objectID];
    [self.navigationController pushViewController:riskgroupviewcontroller animated:YES];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
