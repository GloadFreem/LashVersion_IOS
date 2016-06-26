//
//  InvestPersonCell.m
//  JinZhiT
//
//  Created by Eugene on 16/5/17.
//  Copyright © 2016年 Eugene. All rights reserved.
//

#import "InvestPersonCell.h"

@implementation InvestPersonCell


+ (instancetype)cellWithTableView:(UITableView *)tableView
{
    static NSString *ID = @"person";
    InvestPersonCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass(self) owner:nil options:nil] lastObject];
    }
    return cell;
}


- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    _leftBtn.layer.cornerRadius = 3;
    _leftBtn.layer.masksToBounds = YES;
    _leftBtn.layer.borderColor = colorBlue.CGColor;
    _leftBtn.layer.borderWidth = 0.5;
    
    _middleBtn.layer.cornerRadius = 3;
    _middleBtn.layer.masksToBounds = YES;
    _middleBtn.layer.borderColor = colorBlue.CGColor;
    _middleBtn.layer.borderWidth = 0.5;
    
    _rightBtn.layer.cornerRadius = 3;
    _rightBtn.layer.masksToBounds = YES;
    _rightBtn.layer.borderColor = colorBlue.CGColor;
    _rightBtn.layer.borderWidth = 0.5;
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
