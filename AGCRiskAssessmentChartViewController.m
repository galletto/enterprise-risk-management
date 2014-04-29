//
//  AGCRiskAssessmentChartViewController.m
//  Enterprise Risk Management
//
//  Created by Alessandro on 15/04/14.
//  Copyright (c) 2014 ALARCATX. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AGCRiskAssessmentChartViewController.h"
#import "AGCAssetsSplitViewController.h"
#import "AGCGlobalVariables.h"
#import "AGCAppDelegate.h"
#import "Risk_group.h"

@interface AGCRiskAssessmentChartViewController ()

@end

@implementation AGCRiskAssessmentChartViewController

#define debug 1

#pragma mark - INTERACTION
- (IBAction)AssetsButton:(id)sender {
    
}

- (IBAction)EvCriteriaButton:(id)sender {
    
}

- (IBAction)RiskMatrixButton:(id)sender {

}

- (IBAction)RiskAssessmentButton:(id)sender {

}

#pragma mark - VIEW
- (void)refreshInterface {
    if (debug==1) {
        NSLog(@"Running %@ '%@'", self.class, NSStringFromSelector(_cmd));
    }
    if (self.selectedRiskGroupID) {
        CoreDataHelper *base_de_datos = [CoreDataHelper sharedHelper];
        Risk_group *risk_group =
        (Risk_group*)[base_de_datos.context existingObjectWithID:self.selectedRiskGroupID
                                                           error:nil];
        //self.RiskGroupNameField.text = risk_group.short_name;
        // @"assessment for risk group: "
        self.title=risk_group.code;
        
    }

}
- (void)viewDidLoad {
    if (debug==1) {
        NSLog(@"Running %@ '%@'", self.class, NSStringFromSelector(_cmd));
    }
    [super viewDidLoad];
    
}
- (void)viewWillAppear:(BOOL)animated {
    if (debug==1) {
        NSLog(@"Running %@ '%@'", self.class, NSStringFromSelector(_cmd));
    }
    AGCGlobalVariables *globalVariables = [AGCGlobalVariables sharedManager];
    self.titleLabel.title=globalVariables.selectedRiskGroupTitle;
    
    [self refreshInterface];
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


#pragma mark - Navigation

/*
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
 {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */
- (BOOL) shouldPerformSegueWithIdentifier:(NSString *)identifier sender:(id)sender
{
    return YES;
}



@end
