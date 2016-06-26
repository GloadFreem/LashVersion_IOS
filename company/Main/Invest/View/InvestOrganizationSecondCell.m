//
//  InvestOrganizationSecondCell.m
//  JinZhiT
//
//  Created by Eugene on 16/5/17.
//  Copyright © 2016年 Eugene. All rights reserved.
//

#import "InvestOrganizationSecondCell.h"

@implementation InvestOrganizationSecondCell

+ (instancetype)cellWithTableView:(UITableView *)tableView
{
    static NSString *ID = @"organizationSecond";
    InvestOrganizationSecondCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass(self) owner:nil options:nil] lastObject];
    }
    return cell;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    _firstLabel.layer.cornerRadius = 3;
    _firstLabel.layer.masksToBounds = YES;
    _firstLabel.layer.borderColor = colorBlue.CGColor;
    _firstLabel.layer.borderWidth = 0.5;
    
    _secondLabel.layer.cornerRadius = 3;
    _secondLabel.layer.masksToBounds = YES;
    _secondLabel.layer.borderColor = colorBlue.CGColor;
    _secondLabel.layer.borderWidth = 0.5;
    
    _thirdLabel.layer.cornerRadius = 3;
    _thirdLabel.layer.masksToBounds = YES;
    _thirdLabel.layer.borderColor = colorBlue.CGColor;
    _thirdLabel.layer.borderWidth = 0.5;
    
    _fourthLabel.layer.cornerRadius = 3;
    _fourthLabel.layer.masksToBounds = YES;
    _fourthLabel.layer.borderColor = colorBlue.CGColor;
    _fourthLabel.layer.borderWidth = 0.5;
    
    _fifthLabel.layer.cornerRadius = 3;
    _fifthLabel.layer.masksToBounds = YES;
    _fifthLabel.layer.borderColor = colorBlue.CGColor;
    _fifthLabel.layer.borderWidth = 0.5;
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
