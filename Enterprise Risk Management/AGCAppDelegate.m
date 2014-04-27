//
//  AGCAppDelegate.m
//  Enterprise Risk Management
//
//  Created by Alessandro on 16/03/14.
//  Copyright (c) 2014 Alessandro Galletto. All rights reserved.
//

#pragma mark - Core data imports
#import "AGCAppDelegate.h"
#import "CoreDataHelper.h"
#import "Data_classification.h"
#import "Threat.h"
#import "Integrity_req.h"
#import "Site.h"
#import "Risk_group.h"
#import "Business_process.h"
#import "Impact.h"
#import "Availability_req.h"
#import "Asset_care_criteria.h"
#import "Likelihood.h"
#import "Owner.h"
#import "Risk.h"
#import "Risk_matrix.h"
#import "Risk_level.h"
#import "Asset.h"
#import "unistd.h"

#pragma mark - TableViewControllers imports

@implementation AGCAppDelegate

#define debug 0

#pragma mark - Application Delegates

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // Override point for customization after application launch.
    if (debug==1) {
        NSLog(@"Running %@ '%@'", self.class, NSStringFromSelector(_cmd));
    }
    
#if!TARGET_IPHONE_SIMULATOR
    // Default exception handling code
    NSUserDefaults *settings = [NSUserDefaults standardUserDefaults];
    
    if ([settings boolForKey:@"ExceptionOccurredOnLastRun"])
    {
        // Reset exception occurred flag
        [settings setBool:NO forKey:@"ExceptionOccurredOnLastRunKey"];
        [settings synchronize];
        
        // Notify the user
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"We're sorry"
                                                        message:@"An error occurred on the previous run." delegate:self
                                              cancelButtonTitle:@"Dismiss" otherButtonTitles:nil];
        [alert addButtonWithTitle:@"Email Report"];
        [alert show];
    }
    else
    {
        
        NSSetUncaughtExceptionHandler(&exceptionHandler);
        
        // Redirect stderr output stream to file
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,
                                                             NSUserDomainMask, YES);
        NSString *documentsPath = [paths objectAtIndex:0];
        NSString *stderrPath = [documentsPath stringByAppendingPathComponent:@"RM-stderr.log"];
        
        freopen([stderrPath cStringUsingEncoding:NSASCIIStringEncoding], "w", stderr);
        
    }
#endif
    
    sleep(1);
    [[CoreDataHelper sharedHelper] ensureAppropriateStoreIsLoaded];
    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    if (debug==1) {
        NSLog(@"Running %@ '%@'", self.class, NSStringFromSelector(_cmd));
    }
    [[CoreDataHelper sharedHelper] backgroundSaveContext];
    
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    if (debug==1) {
        NSLog(@"Running %@ '%@'", self.class, NSStringFromSelector(_cmd));
    }
    [[CoreDataHelper sharedHelper] ensureAppropriateStoreIsLoaded];
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    
    if (debug==1) {
        NSLog(@"Running %@ '%@'", self.class, NSStringFromSelector(_cmd));
        }
    
    [self base_de_datos];
    
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    [[CoreDataHelper sharedHelper] backgroundSaveContext];
}

#pragma mark - Button IBActions

#pragma mark - Table View Data source delegates

#pragma mark - Class Methods

- (CoreDataHelper *) base_de_datos {
    if (debug==1) {
        NSLog(@"Running %@ '%@'", self.class, NSStringFromSelector(_cmd));
    }
    
    if (!_coreDataHelper) {
        static dispatch_once_t predicate;
        dispatch_once(&predicate, ^{_coreDataHelper = [CoreDataHelper new];} );
        [_coreDataHelper setupCoreData];
    }
    
    return _coreDataHelper;
}

#pragma mark - Exception handler
void exceptionHandler(NSException *exception)
{
    
    NSLog(@"Uncaught exception: %@\nReason: %@\nUser Info: %@\nCall Stack: %@",
          exception.name, exception.reason, exception.userInfo, exception.callStackSymbols);
    
    //Set flag
    NSUserDefaults *settings = [NSUserDefaults standardUserDefaults];
    
    [settings setBool:YES forKey:@"ExceptionOccurredOnLastRun"];
    [settings synchronize];
}

-(void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,
                                                         NSUserDomainMask, YES);
    NSString *documentsPath = [paths objectAtIndex:0];
    NSString *stderrPath = [documentsPath stringByAppendingPathComponent:@"RM-stderr.log"];
    
    if (buttonIndex == 1)
    {
        // Email a Report
        MFMailComposeViewController *mailComposer = [[MFMailComposeViewController alloc] init];
        mailComposer.mailComposeDelegate = self;
        [mailComposer setSubject:@"Error Report"];
        [mailComposer setToRecipients:[NSArray arrayWithObject:@"support@alarcatx.com"]];
        // Attach log file
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,
                                                             NSUserDomainMask, YES);
        NSString *documentsPath = [paths objectAtIndex:0];
        NSString *stderrPath = [documentsPath stringByAppendingPathComponent:@"RM-stderr.log"];
        
        NSData *data = [NSData dataWithContentsOfFile:stderrPath];
        
        [mailComposer addAttachmentData:data mimeType:@"Text/XML" fileName:@"RM-stderr.log"];
        UIDevice *device = [UIDevice currentDevice];
        NSString *emailBody =
        [NSString stringWithFormat:@"My Model: %@\nMy OS: %@\nMy Version: %@",
         [device model], [device systemName], [device systemVersion]];
        [mailComposer setMessageBody:emailBody isHTML:NO];
        [self.window.rootViewController presentViewController:mailComposer animated:YES
                                                   completion:nil];
        
    }
    
    NSSetUncaughtExceptionHandler(&exceptionHandler);
    
    // Redirect stderr output stream to file
    freopen([stderrPath cStringUsingEncoding:NSASCIIStringEncoding], "w", stderr);
    
}
-(void)mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error
{
    [self.window.rootViewController dismissViewControllerAnimated:YES completion:nil];
}


@end
