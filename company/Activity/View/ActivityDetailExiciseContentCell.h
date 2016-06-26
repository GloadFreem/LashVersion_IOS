//
//  ActivityDetailExiciseContentCell.h
//  JinZhiT
//
//  Created by Eugene on 16/5/21.
//  Copyright © 2016年 Eugene. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ActivityViewModel.h"
@interface ActivityDetailExiciseContentCell : UITableViewCell
@property (nonatomic, retain) ActivityViewModel * model;
@property (strong, nonatomic) IBOutlet UILabel *timeLabel;
@property (strong, nonatomic) IBOutlet UILabel *countLabel;
@property (strong, nonatomic) IBOutlet UILabel *addressLabel;
@property (strong, nonatomic) IBOutlet UILabel *dinstanceLabel;
@property (strong, nonatomic) IBOutlet UIButton *statusButton;

@end
