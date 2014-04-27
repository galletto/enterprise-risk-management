//
//  AGCOwnerTableViewCell.h
//  Enterprise Risk Management
//
//  Created by Alessandro on 12/04/14.
//  Copyright (c) 2014 ALARCATX. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AGCOwnerTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *ownernamelbl;
@property (weak, nonatomic) IBOutlet UILabel *ownersurnamelbl;
@property (weak, nonatomic) IBOutlet UILabel *owneremaillbl;
@property (weak, nonatomic) IBOutlet UIImageView *ownerimagelbl;

@end
