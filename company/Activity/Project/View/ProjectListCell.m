//
//  ProjectListCell.m
//  JinZhiT
//
//  Created by Eugene on 16/5/8.
//  Copyright © 2016年 Eugene. All rights reserved.
//

#import "ProjectListCell.h"

@implementation ProjectListCell

- (void)awakeFromNib {
    // Initialization codeor
    _iconImage.layer.cornerRadius = 30;
    _iconImage.layer.masksToBounds = YES;
    
    _leftLabel.layer.cornerRadius = 3;
    _leftLabel.layer.masksToBounds = YES;
    _leftLabel.layer.borderWidth = 0.5;
    _leftLabel.layer.borderColor = colorBlue.CGColor;
    
    _middleLabel.layer.cornerRadius = 3;
    _middleLabel.layer.masksToBounds = YES;
    _middleLabel.layer.borderWidth = 0.5;
    _middleLabel.layer.borderColor = colorBlue.CGColor;
    _rightLabel.layer.cornerRadius = 3;
    _rightLabel.layer.masksToBounds = YES;
    _rightLabel.layer.borderWidth = 0.5;
    _rightLabel.layer.borderColor = colorBlue.CGColor;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
