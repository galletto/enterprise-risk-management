//
//  AGCAppDelegate.h
//  Enterprise Risk Management
//
//  Created by Alessandro on 16/03/14.
//  Copyright (c) 2014 Alessandro Galletto. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CoreDataHelper.h"
#import <MessageUI/MessageUI.h>
#import <MessageUI/MFMailComposeViewController.h>

#pragma mark - Interface and Protocols

@interface AGCAppDelegate : UIResponder <UIApplicationDelegate,UIAlertViewDelegate,MFMailComposeViewControllerDelegate>
{
#pragma mark - Instance Variables
    
}

#pragma mark - Properties and Outlets

@property (strong, nonatomic) UIWindow *window;
@property (nonatomic, strong, readonly) CoreDataHelper *coreDataHelper;

#pragma mark - Method Declarations

- (CoreDataHelper *) base_de_datos;

@end

