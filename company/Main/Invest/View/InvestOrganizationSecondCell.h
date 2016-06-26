//
//  InvestOrganizationSecondCell.h
//  JinZhiT
//
//  Created by Eugene on 16/5/17.
//  Copyright © 2016年 Eugene. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface InvestOrganizationSecondCell : UITableViewCell


@property (weak, nonatomic) IBOutlet UILabel *firstLabel;

@property (weak, nonatomic) IBOutlet UILabel *secondLabel;

@property (weak, nonatomic) IBOutlet UILabel *thirdLabel;
@property (weak, nonatomic) IBOutlet UILabel *fourthLabel;

@property (weak, nonatomic) IBOutlet UILabel *fifthLabel;







+ (instancetype)cellWithTableView:(UITableView *)tableView;




@end
