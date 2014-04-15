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
#import "CoreDataHelper.h"
#import "Deduplicator.h"
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
    CoreDataHelper *base_de_datos =[CoreDataHelper sharedHelper];
    
    NSFetchRequest *request =
    [NSFetchRequest fetchRequestWithEntityName:@"Risk_group"];
    
    request.sortDescriptors =
    [NSArray arrayWithObjects:
         [NSSortDescriptor sortDescriptorWithKey:@"code" ascending:YES],
         [NSSortDescriptor sortDescriptorWithKey:@"short_name" ascending:YES], nil];
    [request setFetchBatchSize:50];
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
    CoreDataHelper *cdh = [CoreDataHelper sharedHelper];
    [Deduplicator deDuplicateEntityWithName:@"Risk_group"
                    withUniqueAttributeName:@"id"
                          withImportContext:cdh.importContext];
}

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
    Risk_group *risk_group = [self.frc objectAtIndexPath:indexPath];
    
    NSMutableString *title = [NSMutableString stringWithFormat:@"%@%@ %@", risk_group.code, risk_group.short_name, risk_group.desc];
    [title replaceOccurrencesOfString:@"(null)"
         withString:@""
         options:0
         range:NSMakeRange(0, [title length])];
    
    cell.riskgroupcodelbl.text=risk_group.code;
    cell.riskgroupnamelbl.text=risk_group.short_name;
    cell.riskgroupdesclbl.text=risk_group.desc;
    
 
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
        Risk_group *deleteTarget = [self.frc objectAtIndexPath:indexPath];
        [self.frc.managedObjectContext deleteObject:deleteTarget];
        [self.tableView reloadRowsAtIndexPaths:[NSArray arrayWithObject:indexPath]
          withRowAnimation:UITableViewRowAnimationFade];
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
    [[self.frc objectAtIndexPath:indexPath] objectID];
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
