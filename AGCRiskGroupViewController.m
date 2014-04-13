//
//  AGCRiskGroupViewController.m
//  Enterprise Risk Management
//
//  Created by Alessandro on 12/04/14.
//  Copyright (c) 2014 ALARCATX. All rights reserved.
//

#import "AGCRiskGroupViewController.h"
#import "AGCAppDelegate.h"
#import "Risk_group.h"

@interface AGCRiskGroupViewController ()
@property (strong, nonatomic) IBOutlet UIScrollView *scrollView;
@property (strong, nonatomic) IBOutlet UITextField *RiskGroupCodeField;

@end

@implementation AGCRiskGroupViewController

#define debug 0

#pragma mark - INTERACTION
- (IBAction)done:(id)sender {
    if (debug==1) {
        NSLog(@"Running %@ '%@'", self.class, NSStringFromSelector(_cmd));
        }
    [self hideKeyboard];
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)hideKeyboardWhenBackgroundIsTapped {
    if (debug==1) {
        NSLog(@"Running %@ '%@'", self.class, NSStringFromSelector(_cmd));
    }
    UITapGestureRecognizer *tgr =
    [[UITapGestureRecognizer alloc] initWithTarget:self
         action:@selector(hideKeyboard)];
    [tgr setCancelsTouchesInView:NO];
    [self.view addGestureRecognizer:tgr];
}
- (void)hideKeyboard {
    if (debug==1) {
        NSLog(@"Running %@ '%@'", self.class, NSStringFromSelector(_cmd));
    }
    [self.view endEditing:YES];
}

#pragma mark - DELEGATE: UITextField
- (void)textFieldDidBeginEditing:(UITextField *)textField {
    if (debug==1) {
        NSLog(@"Running %@ '%@'", self.class, NSStringFromSelector(_cmd));
    }
    if (textField == self.RiskGroupCodeField) {
        
        if ([self.RiskGroupCodeField.text isEqualToString:@"New Item"]) {
            self.RiskGroupCodeField.text = @"";
            }
        }
}
- (void)textFieldDidEndEditing:(UITextField *)textField {
    if (debug==1) {
        NSLog(@"Running %@ '%@'", self.class, NSStringFromSelector(_cmd));
    }
    AGCCoreDataHelper *base_de_datos =
    [(AGCAppDelegate *)[[UIApplication sharedApplication] delegate] base_de_datos];
    Risk_group *risk_group =
    (Risk_group*)[base_de_datos.context existingObjectWithID:self.selectedRiskGroupID error:nil];
    
    if (textField == self.RiskGroupCodeField) {
        if ([self.RiskGroupCodeField.text isEqualToString:@""]) {
            self.RiskGroupCodeField.text = @"New Item";
            }
        risk_group.code = self.RiskGroupCodeField.text;
        }
  //  else if (textField == self.Risk_groupNameField) {
    //    risk_group.short_name =self.RiskGroupNameeField.text];
      //  }
}


#pragma mark - VIEW
- (void)refreshInterface {
    if (debug==1) {
        NSLog(@"Running %@ '%@'", self.class, NSStringFromSelector(_cmd));
    }
    if (self.selectedRiskGroupID) {
        AGCCoreDataHelper *base_de_datos =
            [(AGCAppDelegate *)[[UIApplication sharedApplication] delegate] base_de_datos];
        Risk_group *risk_group =
        (Risk_group*)[base_de_datos.context existingObjectWithID:self.selectedRiskGroupID
                        error:nil];
        self.RiskGroupCodeField.text = risk_group.code;
       // self.quantityTextField.text = risk_group.short_name;
        }
}
- (void)viewDidLoad {
    if (debug==1) {
        NSLog(@"Running %@ '%@'", self.class, NSStringFromSelector(_cmd));
    }
    [super viewDidLoad];
    [self hideKeyboardWhenBackgroundIsTapped];
    self.RiskGroupCodeField.delegate = self;
}
- (void)viewWillAppear:(BOOL)animated {
    if (debug==1) {
        NSLog(@"Running %@ '%@'", self.class, NSStringFromSelector(_cmd));
    }
    [self refreshInterface];
    if ([self.RiskGroupCodeField.text isEqual:@"New Item"]) {
        self.RiskGroupCodeField.text = @"";
        [self.RiskGroupCodeField becomeFirstResponder];
        }
}
- (void)viewDidDisappear:(BOOL)animated {
    if (debug==1) {
        NSLog(@"Running %@ '%@'", self.class, NSStringFromSelector(_cmd));
    }
    AGCCoreDataHelper *base_de_datos =
    [(AGCAppDelegate *)[[UIApplication sharedApplication] delegate] base_de_datos];
    [base_de_datos saveContext];
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
