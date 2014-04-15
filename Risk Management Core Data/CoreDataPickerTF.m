//
//  CoreDataPickerTF.m
//  v2.0
//
//  Created by Tim Roadley on 09/09/13.
//  Copyright (c) 2013 Tim Roadley. All rights reserved.
//
//  This class is free to use in production applications for owners of "Learning Core Data for iOS" by Tim Roadley
//

#import "CoreDataPickerTF.h"
@implementation CoreDataPickerTF
#define debug 0

#pragma mark - DELEGATE & DATASOURCE: UIPickerView
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    if (debug==1) {
        NSLog(@"Running %@ '%@'", self.class, NSStringFromSelector(_cmd));
    }
    return 1;
}
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    if (debug==1) {
        NSLog(@"Running %@ '%@'", self.class, NSStringFromSelector(_cmd));
    }
    return [self.pickerData count];
}
- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component {
    if (debug==1) {
        NSLog(@"Running %@ '%@'", self.class, NSStringFromSelector(_cmd));
    }
    return 44.0f;
}
- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component {
    if (debug==1) {
        NSLog(@"Running %@ '%@'", self.class, NSStringFromSelector(_cmd));
    }
    return 280.0f;
}
- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    if (debug==1) {
        NSLog(@"Running %@ '%@'", self.class, NSStringFromSelector(_cmd));
    }
    return [self.pickerData objectAtIndex:row];
}
- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    if (debug==1) {
        NSLog(@"Running %@ '%@'", self.class, NSStringFromSelector(_cmd));
    }
    NSManagedObject *object = [self.pickerData objectAtIndex:row];
    [self.pickerDelegate selectedObjectID:object.objectID changedForPickerTF:self];
}

#pragma mark - INTERACTION
- (void)done {
    if (debug==1) {
        NSLog(@"Running %@ '%@'", self.class, NSStringFromSelector(_cmd));
    }
    [self resignFirstResponder];
}
- (void)clear {
    if (debug==1) {
        NSLog(@"Running %@ '%@'", self.class, NSStringFromSelector(_cmd));
    }
    [self.pickerDelegate selectedObjectClearedForPickerTF:self];
    [self resignFirstResponder];
}

#pragma mark - DATA
- (void)fetch {
    [NSException raise:NSInternalInconsistencyException format:
     @"You must override the '%@' method to provide data to the picker",
     NSStringFromSelector(_cmd)];
}
- (void)selectDefaultRow {
    [NSException raise:NSInternalInconsistencyException format:
     @"You must override the '%@' method to set the default picker row",
     NSStringFromSelector(_cmd)];
}

#pragma mark - VIEW
- (UIView *)createInputView {
    if (debug==1) {
        NSLog(@"Running %@ '%@'", self.class, NSStringFromSelector(_cmd));
    }
    self.picker = [[UIPickerView alloc] initWithFrame:CGRectZero];
    self.picker.showsSelectionIndicator = YES;
    self.picker.autoresizingMask = UIViewAutoresizingFlexibleHeight;
    self.picker.dataSource = self;
    self.picker.delegate = self;
    [self fetch];
    return self.picker;
}
- (UIView *)createInputAccessoryView {
    if (debug==1) {
        NSLog(@"Running %@ '%@'", self.class, NSStringFromSelector(_cmd));
    }
    self.showToolbar = YES;
    if (!self.toolbar && self.showToolbar) {
        self.toolbar = [[UIToolbar alloc] init];
        self.toolbar.barStyle = UIBarStyleBlackTranslucent;
        self.toolbar.autoresizingMask = UIViewAutoresizingFlexibleHeight;
        [self.toolbar sizeToFit];
        CGRect frame = self.toolbar.frame;
        frame.size.height = 44.0f;
        self.toolbar.frame = frame;
        
        UIBarButtonItem *clearBtn = [[UIBarButtonItem alloc] initWithTitle:@"Clear"
                                                                     style:UIBarButtonItemStyleBordered
                                                                    target:self
                                                                    action:@selector(clear)];
        
        UIBarButtonItem *spacer = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace
                                                                                target:nil
                                                                                action:nil];
        
        UIBarButtonItem *doneBtn =[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone
                                                                                target:self
                                                                                action:@selector(done)];
        
        NSArray *array = [NSArray arrayWithObjects:clearBtn, spacer, doneBtn, nil];
        [self.toolbar setItems:array];
    }
    return self.toolbar;
}
-  (id)initWithFrame:(CGRect)aRect {
    if (debug==1) {
        NSLog(@"Running %@ '%@'", self.class, NSStringFromSelector(_cmd));
    }
    if (self = [super initWithFrame:aRect]) {
        
        self.inputView = [self createInputView];
        self.inputAccessoryView = [self createInputAccessoryView];
    }
    return self;
}
- (id)initWithCoder:(NSCoder*)aDecoder {
    if (debug==1) {
        NSLog(@"Running %@ '%@'", self.class, NSStringFromSelector(_cmd));
    }
    if (self = [super initWithCoder:aDecoder]) {
        self.inputView = [self createInputView];
        self.inputAccessoryView = [self createInputAccessoryView];
    }
    return self;
}
- (void)deviceDidRotate:(NSNotification*)notification {
    if (debug==1) {
        NSLog(@"Running %@ '%@'", self.class, NSStringFromSelector(_cmd));
    }
    [self.picker setNeedsLayout];
}

@end
