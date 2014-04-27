//
//  AGCRiskGroupViewController.m
//  Enterprise Risk Management
//
//  Created by Alessandro on 12/04/14.
//  Copyright (c) 2014 ALARCATX. All rights reserved.
//

#import "AGCRiskGroupViewController.h"
#import "AGCAppDelegate.h"
#import "AGCDatePickerViewController.h"
#import "Risk_group.h"
#import "Risk_group_photo.h"

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
@property (strong, nonatomic) IBOutlet UIImageView *photoImageView;
- (IBAction)albumButton:(UIButton *)sender;
- (IBAction)cameraButton:(UIButton *)sender;
@property (strong, nonatomic) IBOutlet UIButton *cameraButtonstatus;

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
    if (_newRiskGroup)
    {
        CoreDataHelper *base_de_datos = [CoreDataHelper sharedHelper];
        Risk_group *risk_group =
                                (Risk_group*)[base_de_datos.context existingObjectWithID:self.selectedRiskGroupID
                                                                                   error:nil];
        [base_de_datos.context deleteObject:risk_group];
    }
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

-(void) keyboardDidShow:(NSNotification *) notif {
    if (debug==1) {
        NSLog(@"Running %@ '%@'", self.class, NSStringFromSelector(_cmd));
    }
    //Find top of the keyboard input view
    CGRect keyboardRect=[[[notif userInfo] objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
    keyboardRect=[self.view convertRect:keyboardRect fromView:nil];
    CGFloat keyboardTop=keyboardRect.origin.y;
    
    //Resize scroll view
    CGRect newScrollViewFrame=CGRectMake(0, 0, self.view.bounds.size.width, keyboardTop);
    newScrollViewFrame.size.height=keyboardTop - self.view.bounds.origin.y;
    [self.scrollView setFrame:newScrollViewFrame];
    
    //Scroll to the active textfield
    [self.scrollView scrollRectToVisible:self.activeField.frame animated:YES];
    
}

-(void) keyboardWillHide:(NSNotification *) notif{
    if (debug==1) {
        NSLog(@"Running %@ '%@'", self.class, NSStringFromSelector(_cmd));
    }
    CGRect defaultFrame=CGRectMake(self.scrollView.frame.origin.x, self.scrollView.frame.origin.y, self.view.frame.size.width, self.view.frame.size.height);
    
    // Reset scrollview to the same size of the containing view
    [self.scrollView setFrame:defaultFrame];
    
    //Scroll to the top again
    [self.scrollView scrollRectToVisible:self.RiskGroupCodeField.frame
                                 animated:YES];
}

#pragma mark - DELEGATE: UITextField
- (void)textFieldDidBeginEditing:(UITextField *)textField {
    if (debug==1) {
        NSLog(@"Running %@ '%@'", self.class, NSStringFromSelector(_cmd));
    }
    if (textField == self.RiskGroupCodeField) {
        
        if ([self.RiskGroupCodeField.text isEqualToString:@"NewRiskGroup"]) {
            self.RiskGroupCodeField.text = @"";
        }
    }
    
    _activeField=textField;
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    if ([textField isKindOfClass:[UITextView class]]==YES) return YES;
    
    if (textField == self.RiskGroupLastModifiedAtField) {
        //Assign DatePicker to LastModifiedAt TextField
        //build our custom popover view
        self.popoverContent = [[AGCDatePickerViewController alloc] init];
        self.popoverContent =[[UIStoryboard storyboardWithName:@"main"
                                                   bundle:nil]
                         instantiateViewControllerWithIdentifier:@"DatePickerVC"];
        
        //resize the popover view shown
        //in the current view to the view's size
        self.popoverContent.preferredContentSize = CGSizeMake(320, 216);
        
        // dismiss existing popover
        if (self.datePickerController)
        {
            [self.datePickerController dismissPopoverAnimated:NO];
            self.datePickerController = nil;
        }
        
        //create a popover controller with my DatePickerViewController in it
        UIPopoverController *popoverControllerForDate = [[UIPopoverController alloc] initWithContentViewController:self.popoverContent];
        //Set the delegate to self to receive the data of the Datepicker in the popover
        popoverControllerForDate.delegate = self;
        
        //Adjust the popover Frame to appear where I want
        CGRect myFrame =self.RiskGroupLastModifiedAtField.frame;
        //myFrame.origin.x = 260;
        //myFrame.origin.y = 320;
        
        //Present the popover
        [popoverControllerForDate presentPopoverFromRect:myFrame
                                                  inView:self.view
                                permittedArrowDirections:UIPopoverArrowDirectionDown
                                                animated:YES];
        self.datePickerController = popoverControllerForDate;
        return NO; // tells the textfield not to start its own editing process (ie show the keyboard)
        
    }
    else {
        // dismiss existing popover
        if (self.datePickerController)
        {
            [self.datePickerController dismissPopoverAnimated:NO];
            self.datePickerController = nil;
        }
        return YES;
    }
}
-(BOOL)popoverControllerShouldDismissPopover:(UIPopoverController *)popoverController
{
    
    
    self.RiskGroupLastModifiedAtField.text = [NSDateFormatter localizedStringFromDate:self.popoverContent.datePicker.date
                                                                            dateStyle:NSDateFormatterLongStyle
                                                                            timeStyle:NSDateFormatterNoStyle];
    
    NSLog(@"%@, %@",self.popoverContent.datePicker.description, self.popoverContent.datePicker.date);

    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    if (debug==1) {
        NSLog(@"Running %@ '%@'", self.class, NSStringFromSelector(_cmd));
    }
    [textField resignFirstResponder];
    
    if (textField==self.RiskGroupCodeField) [self.RiskGroupNameField becomeFirstResponder];
   else
    if (textField==self.RiskGroupNameField) [self.RiskGroupDescField becomeFirstResponder];
   else
    if (textField==self.RiskGroupCompanyField) [self.RiskGroupAuthorField becomeFirstResponder];
   else
    if (textField==self.RiskGroupAuthorField) [self.RiskGroupCreatedAtField becomeFirstResponder];
   else
    if (textField==self.RiskGroupCreatedAtField) [self.RiskGroupLastModifiedField becomeFirstResponder];
   else
    if (textField==self.RiskGroupLastModifiedField) [self.RiskGroupCodeField becomeFirstResponder];
   
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
            self.RiskGroupCodeField.text = @"NewRiskGroup";
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
        risk_group.updated_at= [NSDate date];
        if([risk_group.code isEqualToString:@""]) self.RiskGroupCodeField.text=@"NewRiskGroup";
            else self.RiskGroupCodeField.text = risk_group.code;
        self.RiskGroupNameField.text = risk_group.short_name;
        self.RiskGroupDescField.text = risk_group.desc;
        self.RiskGroupCompanyField.text = risk_group.company;
        self.RiskGroupAuthorField.text = risk_group.created_by;
        self.RiskGroupCreatedAtField.text = [NSDateFormatter localizedStringFromDate: risk_group.created_at
                                                                           dateStyle: NSDateFormatterLongStyle
                                                                           timeStyle: NSDateFormatterNoStyle];
        self.RiskGroupLastModifiedField.text = risk_group.updated_by;
        self.RiskGroupLastModifiedAtField.text = [NSDateFormatter localizedStringFromDate: risk_group.updated_at
                                                                                dateStyle: NSDateFormatterLongStyle
                                                                                timeStyle: NSDateFormatterNoStyle];
        [base_de_datos.context performBlock:^{
              self.photoImageView.image=[UIImage imageWithData:risk_group.photo.data];
                }];
        
        [self checkCamera];
        }
    else self.RiskGroupCodeField.text=@"NewRiskGroup";
   
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
    self.scrollView.contentSize = CGSizeMake(768.0f, 800.0f);
}

- (void)viewWillAppear:(BOOL)animated {
    if (debug==1) {
        NSLog(@"Running %@ '%@'", self.class, NSStringFromSelector(_cmd));
    }
    // Register for keyboard notifications while the view is visible
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDidShow:) name:UIKeyboardDidShowNotification object:self.view.window];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:)  name:UIKeyboardWillHideNotification object:self.view.window];
    
    [self refreshInterface];
    
}
- (void)viewDidDisappear:(BOOL)animated {
    if (debug==1) {
        NSLog(@"Running %@ '%@'", self.class, NSStringFromSelector(_cmd));
    }
    CoreDataHelper *base_de_datos =[CoreDataHelper sharedHelper];
    [base_de_datos backgroundSaveContext];
    
    //Unregister for keyboard notification while the view is not visible
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardDidShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
    
    // Turn risk & risk photo into a fault
    NSError *error;
    Risk_group *riskGroup =
    (Risk_group *)[base_de_datos.context existingObjectWithID:self.selectedRiskGroupID error:&error];
    if (error) {
        NSLog(@"ERROR!!! --> %@", error.localizedDescription);
    } else {
        [base_de_datos.context refreshObject:riskGroup.thumbnail mergeChanges:NO];
        [base_de_datos.context refreshObject:riskGroup mergeChanges:NO];
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

#pragma mark - CAMERA
- (void)checkCamera {
    if (debug==1) {
        NSLog(@"Running %@ '%@'", self.class, NSStringFromSelector(_cmd));
    }
    self.cameraButtonstatus.enabled =
        [UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera];
}


- (void)imagePickerController:(UIImagePickerController *)picker
didFinishPickingMediaWithInfo:(NSDictionary *)info {
    if (debug==1) {
        NSLog(@"Running %@ '%@'", self.class, NSStringFromSelector(_cmd));
        }
    CoreDataHelper *base_de_datos = [CoreDataHelper sharedHelper];
    
    Risk_group *risk_group = (Risk_group*)[base_de_datos.context existingObjectWithID:self.selectedRiskGroupID error:nil];
    
    UIImage *photo = (UIImage *)[info objectForKey:UIImagePickerControllerEditedImage];
    
    NSLog(@"Captured %f x %f photo",photo.size.height, photo.size.width);
    
    if (!risk_group.photo) { // Create photo object it doesn't exist
        Risk_group_photo *newPhoto =
        [NSEntityDescription insertNewObjectForEntityForName:@"Risk_group_photo"
                                      inManagedObjectContext:base_de_datos.context];
        [base_de_datos.context obtainPermanentIDsForObjects:
         [NSArray arrayWithObject:newPhoto] error:nil];
        risk_group.photo = newPhoto;
    }
    risk_group.photo.data = UIImageJPEGRepresentation(photo, 0.5);
    risk_group.thumbnail = nil;
    
    self.photoImageView.image = photo;
    
    [picker dismissViewControllerAnimated:YES completion:nil];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    if (debug==1) {
        NSLog(@"Running %@ '%@'", self.class, NSStringFromSelector(_cmd));
    }
    [picker dismissViewControllerAnimated:YES completion:nil];
}
        
- (IBAction)cameraButton:(UIButton *)sender {
    if (debug==1) {
        NSLog(@"Running %@ '%@'", self.class, NSStringFromSelector(_cmd));
    }
    if ([UIImagePickerController
         isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
    {
        NSLog(@"Camera is available");
        _camera = [[UIImagePickerController alloc] init];
        _camera.sourceType = UIImagePickerControllerSourceTypeCamera;
        _camera.mediaTypes = [UIImagePickerController
                              availableMediaTypesForSourceType:UIImagePickerControllerSourceTypeCamera];
        _camera.allowsEditing = YES;
        _camera.delegate = self;
        [self.navigationController presentViewController:_camera
                                                animated:YES
                                              completion:nil];
    }
    else
    {
        NSLog(@"Camera not available");
    }
}
- (IBAction)albumButton:(UIButton *)sender {
    if (debug==1) {
        NSLog(@"Running %@ '%@'", self.class, NSStringFromSelector(_cmd));
    }
    if ([UIImagePickerController
         isSourceTypeAvailable:UIImagePickerControllerSourceTypeSavedPhotosAlbum])
    {
        NSLog(@"Album is available");
        _camera = [[UIImagePickerController alloc] init];
        _camera.sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
        _camera.mediaTypes = [UIImagePickerController
                              availableMediaTypesForSourceType:UIImagePickerControllerSourceTypeSavedPhotosAlbum];
        _camera.allowsEditing = YES;
        _camera.delegate = self;
        [self.navigationController presentViewController:_camera
                                                animated:YES
                                              completion:nil];
    }
    else
    {
        NSLog(@"Album not available");
    }

}
@end
