//
//  AGCOwnerViewController.h
//  risk manager
//
//  Created by Alessandro on 26/04/14.
//  Copyright (c) 2014 ALARCATX. All rights reserved.
//

#import <UIKit/UIKit.h>
@class Owner;
#import "AGCOwnerSelectionDelegate.h"

@interface AGCOwnerViewController :  UIViewController <UITextFieldDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UIPopoverControllerDelegate, UISplitViewControllerDelegate, AGCOwnerSelectionDelegate>

@property (nonatomic) BOOL newOwner;
@property (strong, nonatomic) NSManagedObjectID *selectedOwnerID;
@property (strong, nonatomic) IBOutlet UITextField *activeField;
@property (strong, nonatomic) UIImagePickerController *camera;
@property (strong, nonatomic) UIPopoverController *datePickerController;

@end


