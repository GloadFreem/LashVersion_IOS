//
//  InvestOrganizationCell.h
//  JinZhiT
//
//  Created by Eugene on 16/5/17.
//  Copyright © 2016年 Eugene. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OrganizationFirstModel.h"

@interface InvestOrganizationCell : UITableViewCell

@property (nonatomic, strong) OrganizationFirstModel *model;

@property (weak, nonatomic) IBOutlet UIImageView *iconImage;
@property (weak, nonatomic) IBOutlet UILabel *name;

@property (weak, nonatomic) IBOutlet UILabel *content;


+ (instancetype)cellWithTableView:(UITableView *)tableView;



@end
