//
//  IdentityTableViewCell.m
//  JinZhiT
//
//  Created by Eugene on 16/5/6.
//  Copyright © 2016年 Eugene. All rights reserved.
//

#import "IdentityTableViewCell.h"

@implementation IdentityTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)btnClick:(UIButton *)sender {
    
    if ([self.delegate respondsToSelector:@selector(didClickBtnInCell:andTag:)]) {
        [self.delegate didClickBtnInCell:self andTag:sender.tag];
    }
}


@end
