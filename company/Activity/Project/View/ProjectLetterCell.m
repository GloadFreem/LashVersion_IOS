//
//  ProjectLetterCell.m
//  JinZhiT
//
//  Created by Eugene on 16/5/21.
//  Copyright © 2016年 Eugene. All rights reserved.
//

#import "ProjectLetterCell.h"

@implementation ProjectLetterCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}


-(void)relayoutCellWithModel:(ProjectLetterModel*)model
{
    _model = model;
    _titleLabel.text = model.titleLabel;
    if (_model.selectedStatus) {
        [_selectImage setImage:[UIImage imageNamed:@"letterSelected"]];
    }else{
        [_selectImage setImage:[UIImage imageNamed:@"letterUnselected"]];
    }
    
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
