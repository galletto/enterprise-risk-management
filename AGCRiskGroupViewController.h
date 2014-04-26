//
//  AGCRiskGroupViewController.h
//  Enterprise Risk Management
//
//  Created by Alessandro on 12/04/14.
//  Copyright (c) 2014 ALARCATX. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AGCDatePickerViewController.h"

@interface AGCRiskGroupViewController : UIViewController <UITextFieldDelegate, UITextViewDelegate,UINavigationControllerDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UIPopoverControllerDelegate>

@property (nonatomic) BOOL newRiskGroup;
@property (strong, nonatomic) NSManagedObjectID *selectedRiskGroupID;
@property (strong, nonatomic) IBOutlet UITextField *activeField;
@property (strong, nonatomic) UIImagePickerController *camera;
@property (strong, nonatomic) UIPopoverController *datePickerController;
@property (strong, nonatomic) AGCDatePickerViewController* popoverContent;

@end
