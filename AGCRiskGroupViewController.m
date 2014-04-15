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
@property (strong, nonatomic) IBOutlet UITextField *RiskGroupNameField;
@property (strong, nonatomic) IBOutlet UITextView *RiskGroupDescField;
@property (strong, nonatomic) IBOutlet UITextField *RiskGroupCompanyField;
@property (strong, nonatomic) IBOutlet UITextField *RiskGroupAuthorField;
@property (strong, nonatomic) IBOutlet UITextField *RiskGroupCreatedAtField;
@property (strong, nonatomic) IBOutlet UITextField *RiskGroupLastModifiedField;
@property (strong, nonatomic) IBOutlet UITextField *RiskGroupLastModifiedAtField;

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

- (IBAction)cancel:(id)sender {
    if (debug==1) {
        NSLog(@"Running %@ '%@'", self.class, NSStringFromSelector(_cmd));
    }
    [self hideKeyboard];
//    CoreDataHelper *base_de_datos =[CoreDataHelper sharedHelper];
//    Hay que ver cómo borro el objeto selectedRiskGroupID
    CoreDataHelper *base_de_datos = [CoreDataHelper sharedHelper];
    Risk_group *risk_group =
    (Risk_group*)[base_de_datos.context existingObjectWithID:self.selectedRiskGroupID
                                                       error:nil];
   // [risk_group dele
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
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    if (debug==1) {
        NSLog(@"Running %@ '%@'", self.class, NSStringFromSelector(_cmd));
    }
    [textField resignFirstResponder];
    return YES;
}
- (void)textFieldDidEndEditing:(UITextField *)textField {
    if (debug==1) {
        NSLog(@"Running %@ '%@'", self.class, NSStringFromSelector(_cmd));
    }
    CoreDataHelper *base_de_datos = [CoreDataHelper sharedHelper];
    Risk_group *risk_group =
    (Risk_group*)[base_de_datos.context existingObjectWithID:self.selectedRiskGroupID error:nil];
    
    if (textField == self.RiskGroupCodeField) {
        if ([self.RiskGroupCodeField.text isEqualToString:@""]) {
            self.RiskGroupCodeField.text = @"New Item";
            }
        risk_group.code = self.RiskGroupCodeField.text;
        }
    else if (textField == self.RiskGroupNameField)
        risk_group.short_name =self.RiskGroupNameField.text;
    
        else if (textField == (UITextField *) self.RiskGroupDescField)
            risk_group.desc =self.RiskGroupDescField.text;
            
            else if (textField == self.RiskGroupCompanyField)
                risk_group.company =self.RiskGroupCompanyField.text;
    
                else if (textField == self.RiskGroupAuthorField)
                    risk_group.created_by =self.RiskGroupAuthorField.text;
    
                    else if (textField == self.RiskGroupCreatedAtField)
                    {
                        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
                        // this is imporant - we set our input date format to match our input string
                        // if format doesn't match you'll get nil from your string, so be careful
                        [dateFormatter setDateFormat:@"dd-MM-yyyy"];
                        risk_group.created_at = [dateFormatter dateFromString:self.RiskGroupCreatedAtField.text];
                        
                    }
                        else if (textField == self.RiskGroupLastModifiedField)
                            risk_group.updated_by =self.RiskGroupLastModifiedField.text;
    
                            else if (textField == self.RiskGroupLastModifiedAtField)
                            {
                                NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
                                // this is imporant - we set our input date format to match our input string
                                // if format doesn't match you'll get nil from your string, so be careful
                                [dateFormatter setDateFormat:@"dd-MM-yyyy"];
                                risk_group.updated_at = [dateFormatter dateFromString:self.RiskGroupLastModifiedField.text];
                                
                            }
    
}
- (void)textViewDidEndEditing:(UITextView *)textView {
    if (debug==1) {
        NSLog(@"Running %@ '%@'", self.class, NSStringFromSelector(_cmd));
    }
    CoreDataHelper *base_de_datos = [CoreDataHelper sharedHelper];
    Risk_group *risk_group =
    (Risk_group*)[base_de_datos.context existingObjectWithID:self.selectedRiskGroupID error:nil];
    
    if (textView == (UITextView *) self.RiskGroupDescField)
        risk_group.desc =self.RiskGroupDescField.text;
    
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if (debug==1) {
        NSLog(@"Running %@ '%@'", self.class, NSStringFromSelector(_cmd));
    }
    if (textField == self.RiskGroupCreatedAtField || textField == self.RiskGroupLastModifiedAtField)
   {
    NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init] ;
    if([string length]==0)
    {
        [formatter setGroupingSeparator:@"-"];
        [formatter setGroupingSize:4];
        [formatter setUsesGroupingSeparator:YES];
        [formatter setSecondaryGroupingSize:2];
        NSString *num = textField.text ;
        num= [num stringByReplacingOccurrencesOfString:@"-" withString:@""];
        NSString *str = [formatter stringFromNumber:[NSNumber numberWithDouble:[num doubleValue]]];
        textField.text=str;
        return YES;
    }
    else {
        [formatter setGroupingSeparator:@"-"];
        [formatter setGroupingSize:2];
        [formatter setUsesGroupingSeparator:YES];
        [formatter setSecondaryGroupingSize:2];
        NSString *num = textField.text ;
        if(![num isEqualToString:@""])
        {
            num= [num stringByReplacingOccurrencesOfString:@"-" withString:@""];
            NSString *str = [formatter stringFromNumber:[NSNumber numberWithDouble:[num doubleValue]]];
            textField.text=str;
        }
        return YES;
    }
       
    //[formatter setLenient:YES];
   }
    return YES;
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
        self.RiskGroupCodeField.text = risk_group.code;
        self.RiskGroupNameField.text = risk_group.short_name;
        self.RiskGroupDescField.text = risk_group.desc;
        self.RiskGroupCompanyField.text = risk_group.company;
        self.RiskGroupAuthorField.text = risk_group.created_by;
        self.RiskGroupCreatedAtField.text = risk_group.created_at.description;
        self.RiskGroupLastModifiedField.text = risk_group.updated_by;
        self.RiskGroupLastModifiedAtField.text = risk_group.updated_at.description;

        }
}
- (void)viewDidLoad {
    if (debug==1) {
        NSLog(@"Running %@ '%@'", self.class, NSStringFromSelector(_cmd));
    }
    [super viewDidLoad];
    [self hideKeyboardWhenBackgroundIsTapped];
    self.RiskGroupCodeField.delegate = self;
    self.RiskGroupNameField.delegate = self;
    self.RiskGroupDescField.delegate = self;
    self.RiskGroupCompanyField.delegate = self;
    self.RiskGroupAuthorField.delegate=self;
    self.RiskGroupCreatedAtField.delegate=self;
    self.RiskGroupLastModifiedField.delegate=self;
    self.RiskGroupLastModifiedAtField.delegate=self;
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
    CoreDataHelper *base_de_datos = [CoreDataHelper sharedHelper];
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
    if (debug==1) {
        NSLog(@"Running %@ '%@'", self.class, NSStringFromSelector(_cmd));
    }
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
