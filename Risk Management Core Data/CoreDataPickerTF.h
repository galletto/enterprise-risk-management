//
//  CoreDataPickerTF.h
//  v2.0
//
//  Created by Tim Roadley on 09/09/13.
//  Copyright (c) 2013 Tim Roadley. All rights reserved.
//
//  This class is free to use in production applications for owners of "Learning Core Data for iOS" by Tim Roadley
//

#import <UIKit/UIKit.h>
#import "CoreDataHelper.h"
@class CoreDataPickerTF;
@protocol CoreDataPickerTFDelegate <NSObject>
- (void)selectedObjectID:(NSManagedObjectID*)objectID
      changedForPickerTF:(CoreDataPickerTF*)pickerTF;
@optional
- (void)selectedObjectClearedForPickerTF:(CoreDataPickerTF*)pickerTF;
@end

@interface CoreDataPickerTF : UITextField
<UIKeyInput, UIPickerViewDelegate, UIPickerViewDataSource>
@property (nonatomic, weak) id <CoreDataPickerTFDelegate> pickerDelegate;
@property (nonatomic, strong) UIPickerView *picker;
@property (nonatomic, strong) NSArray *pickerData;
@property (nonatomic, strong) UIToolbar *toolbar;
@property (nonatomic) BOOL showToolbar;
@property (nonatomic, strong) NSManagedObjectID *selectedObjectID;
@end
