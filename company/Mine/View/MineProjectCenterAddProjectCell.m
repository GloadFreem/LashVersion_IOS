//
//  MineProjectCenterAddProjectCell.m
//  company
//
//  Created by Eugene on 16/6/29.
//  Copyright © 2016年 Eugene. All rights reserved.
//

#import "MineProjectCenterAddProjectCell.h"

@implementation MineProjectCenterAddProjectCell



+ (instancetype)cellWithTableView:(UITableView *)tableView
{
    static NSString *ID = @"MineProjectCenterAddProjectCell";
    MineProjectCenterAddProjectCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass(self) owner:nil options:nil] lastObject];
    }
    return cell;
}



- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
