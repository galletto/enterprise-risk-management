//
//  AGCRiskGroupTableViewCell.h
//  Enterprise Risk Management
//
//  Created by Alessandro on 12/04/14.
//  Copyright (c) 2014 ALARCATX. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AGCRiskGroupTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *riskgroupcodelbl;
@property (weak, nonatomic) IBOutlet UILabel *riskgroupnamelbl;
@property (weak, nonatomic) IBOutlet UILabel *riskgroupdesclbl;
@property (weak, nonatomic) IBOutlet UIImageView *riskgroupimagelbl;

@end
