//
//  AGCDismissSegue.m
//  Enterprise Risk Management
//
//  Created by Alessandro on 15/04/14.
//  Copyright (c) 2014 ALARCATX. All rights reserved.
//

#import "AGCDismissSegue.h"

@implementation AGCDismissSegue

- (void)perform {
    UIViewController *sourceViewController = self.sourceViewController;
    [sourceViewController.presentingViewController dismissViewControllerAnimated:YES completion:nil];
}

@end
