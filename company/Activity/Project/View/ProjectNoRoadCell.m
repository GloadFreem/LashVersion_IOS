//
//  ProjectNoRoadCell.m
//  JinZhiT
//
//  Created by Eugene on 16/5/9.
//  Copyright © 2016年 Eugene. All rights reserved.
//

#import "ProjectNoRoadCell.h"

@implementation ProjectNoRoadCell

- (void)awakeFromNib {
    // Initialization code
    _iconImage.layer.cornerRadius = 30;
    _iconImage.layer.masksToBounds = YES;
    
    _leftBtn.layer.cornerRadius = 3;
    _leftBtn.layer.masksToBounds = YES;
    _leftBtn.layer.borderWidth = 0.5;
    _leftBtn.layer.borderColor = colorBlue.CGColor;
    
    _middleBtn.layer.cornerRadius = 3;
    _middleBtn.layer.masksToBounds = YES;
    _middleBtn.layer.borderWidth = 0.5;
    _middleBtn.layer.borderColor = colorBlue.CGColor;
    
    _rightBtn.layer.cornerRadius = 3;
    _rightBtn.layer.masksToBounds = YES;
    _rightBtn.layer.borderWidth = 0.5;
    _rightBtn.layer.borderColor = colorBlue.CGColor;
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
