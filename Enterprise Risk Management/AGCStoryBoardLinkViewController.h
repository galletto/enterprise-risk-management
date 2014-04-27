//
//  AGCStoryBoardLinkViewController.h
//  Enterprise Risk Management
//
//  Created by Alessandro on 15/04/14.
//  Copyright (c) 2014 ALARCATX. All rights reserved.
//

#import <UIKit/UIKit.h>



/**
 * What this class does is create a linked scene, put it in a
 * containter view controller, and copy all the linked scene's properties into
 * the container view controller.
 */
@interface AGCStoryBoardLinkViewController : UIViewController

/// The contained UIViewController from the destination view controller.
@property (nonatomic, strong, readonly) UIViewController * scene;

/// The name of the storyboard that should be linked.
/// This should be set in the Interface Builder identity inspector.
@property (nonatomic, copy) NSString * storyboardName;

/// (Optional) The identifier of the scene to show.
/// This should be set in the Interface Builder identity inspector.
@property (nonatomic, copy) NSString * sceneIdentifier;

/// (Optional) Whether the first view controller should have a constraint for
/// the top layout guide in the storyboard. This should be set in the Interface
/// Builder identity inspector.
@property (nonatomic, assign) BOOL needsTopLayoutGuide;

/// (Optional) Whether the first view controller should have a constraint for
/// the bottom layout guide in the storyboard. This should be set in the
/// Interface Builder identity inspector.
@property (nonatomic, assign) BOOL needsBottomLayoutGuide;

@end