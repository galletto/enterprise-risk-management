//
//  AGCOwnerViewController.m
//  risk manager
//
//  Created by Alessandro on 26/04/14.
//  Copyright (c) 2014 ALARCATX. All rights reserved.
//

#import "AGCOwnerViewController.h"
#import "AGCAppDelegate.h"
#import "Owner.h"
#import "Owner_photo.h"

@interface AGCOwnerViewController ()
@property (strong, nonatomic) IBOutlet UIScrollView *scrollView;
@property (strong, nonatomic) IBOutlet UITextField *OwnerNameField;
@property (strong, nonatomic) IBOutlet UITextField *OwnerSurnameField;
@property (strong, nonatomic) IBOutlet UITextField *OwnerEmailField;
@property (strong, nonatomic) IBOutlet UITextField *OwnerMobileField;
@property (strong, nonatomic) IBOutlet UIImageView *photoImageView;
- (IBAction)albumButton:(UIButton *)sender;
- (IBAction)cameraButton:(UIButton *)sender;
@property (strong, nonatomic) IBOutlet UIButton *cameraButtonstatus;

@end

@implementation AGCOwnerViewController

#define debug 1

#pragma mark - INTERACTION
- (IBAction)done:(id)sender {
    if (debug==1) {
        NSLog(@"Running %@ '%@'", self.class, NSStringFromSelector(_cmd));
    }
    [self hideKeyboard];
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
    [self.scrollView scrollRectToVisible:self.OwnerNameField.frame
                                animated:YES];
}

#pragma mark - DELEGATE: UITextField
- (void)textFieldDidBeginEditing:(UITextField *)textField {
    if (debug==1) {
        NSLog(@"Running %@ '%@'", self.class, NSStringFromSelector(_cmd));
    }
    if (textField == self.OwnerNameField) {
        
        if ([self.OwnerNameField.text isEqualToString:@"NewOwner"]) {
            self.OwnerNameField.text = @"";
        }
    }
    _activeField=textField;
}


- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    if (debug==1) {
        NSLog(@"Running %@ '%@'", self.class, NSStringFromSelector(_cmd));
    }
    [textField resignFirstResponder];
    
    if (textField==self.OwnerNameField) [self.OwnerSurnameField becomeFirstResponder];
    else
        if (textField==self.OwnerSurnameField) [self.OwnerEmailField becomeFirstResponder];
        else
            if (textField==self.OwnerEmailField) [self.OwnerMobileField becomeFirstResponder];
                    else
                        if (textField==self.OwnerMobileField) [self.OwnerNameField becomeFirstResponder];
    
    return YES;
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    if (debug==1) {
        NSLog(@"Running %@ '%@'", self.class, NSStringFromSelector(_cmd));
    }
    CoreDataHelper *base_de_datos = [CoreDataHelper sharedHelper];
    Owner *owner =
    (Owner *)[base_de_datos.context existingObjectWithID:self.selectedOwnerID error:nil];
    
    if (textField == self.OwnerNameField) {
        if ([self.OwnerNameField.text isEqualToString:@""]) {
            self.OwnerNameField.text = @"NewOwner";
        }
        owner.name = self.OwnerNameField.text;
    }
    else if (textField == self.OwnerSurnameField)
        owner.surname =self.OwnerSurnameField.text;
    else if (textField == self.OwnerEmailField)
        owner.email =self.OwnerEmailField.text;
    
    else if (textField == self.OwnerMobileField)
        owner.mobile =self.OwnerMobileField.text;
}

#pragma mark - VIEW
- (void)refreshInterface {
    if (debug==1) {
        NSLog(@"Running %@ '%@'", self.class, NSStringFromSelector(_cmd));
    }
    if (self.selectedOwnerID) {
        CoreDataHelper *base_de_datos = [CoreDataHelper sharedHelper];
       
        NSError *errordb=nil;
       Owner *owner = (Owner *)[base_de_datos.context existingObjectWithID:self.selectedOwnerID
                                                                     error:&errordb];
        NSLog(@" %@", errordb);
        owner.updated_at= [NSDate date];
        if([owner.name isEqualToString:@""]) self.OwnerNameField.text=@"NewOwner";
        else self.OwnerNameField.text = owner.name;
        self.OwnerSurnameField.text = owner.surname;
        self.OwnerEmailField.text = owner.email;
        self.OwnerMobileField.text = owner.mobile;
    //    self.OwnerModifiedAt.text = [NSDateFormatter localizedStringFromDate: owner.updated_at
    //                                                                           dateStyle: NSDateFormatterLongStyle
    //                                                                            timeStyle: NSDateFormatterNoStyle];
        [base_de_datos.context performBlock:^{
            self.photoImageView.image=[UIImage imageWithData:owner.photo.data];
        }];
        
        [self checkCamera];
    }
    else self.OwnerNameField.text=@"NewOwner";
    
}
- (void)viewDidLoad {
    if (debug==1) {
        NSLog(@"Running %@ '%@'", self.class, NSStringFromSelector(_cmd));
    }
    [super viewDidLoad];
    [self hideKeyboardWhenBackgroundIsTapped];
    self.OwnerNameField.delegate = self;
    self.OwnerSurnameField.delegate = self;
    self.OwnerEmailField.delegate = self;
    self.OwnerMobileField.delegate = self;
   // self.OwnerLastModifiedAtField.delegate=self;
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
    if (self.selectedOwnerID!=nil)
    {
        Owner *owner = (Owner *)[base_de_datos.context existingObjectWithID:self.selectedOwnerID error:&error];
        if (error) {
            NSLog(@"ERROR!!! --> %@", error.localizedDescription);
        } else {
            [base_de_datos.context refreshObject:owner.thumbnail mergeChanges:NO];
            [base_de_datos.context refreshObject:owner mergeChanges:NO];
        }
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
    
    Owner *owner = (Owner*)[base_de_datos.context existingObjectWithID:self.selectedOwnerID error:nil];
    
    UIImage *photo = (UIImage *)[info objectForKey:UIImagePickerControllerEditedImage];
    
    NSLog(@"Captured %f x %f photo",photo.size.height, photo.size.width);
    
    if (!owner.photo) { // Create photo object it doesn't exist
        Owner_photo *newPhoto =
        [NSEntityDescription insertNewObjectForEntityForName:@"Owner_photo"
                                      inManagedObjectContext:base_de_datos.context];
        [base_de_datos.context obtainPermanentIDsForObjects:
         [NSArray arrayWithObject:newPhoto] error:nil];
        owner.photo = newPhoto;
    }
    owner.photo.data = UIImageJPEGRepresentation(photo, 0.5);
    owner.thumbnail = nil;
    
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


#pragma mark - Owner Selection Delegate
-(void)selectedOwner:(NSManagedObjectID *)newOwnerID
{
    
    self.selectedOwnerID=newOwnerID;
    [self refreshInterface];
    
}

@end
