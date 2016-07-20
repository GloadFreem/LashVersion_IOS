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


-(void)relayoutCellWithModel:(LetterBaseModel*)model
{
    _model = model;
    _titleLabel.text = model.title;
    _timeLabel.text = model.messageDate;
    _secondTitle.text = model.messagetype.name;
    _contentLabel.text = model.content;
    
    if (model.isRead) {
        [_redPointImage setHidden:YES];
    }else{
        [_redPointImage setHidden:NO];
    }
    
    if (_model.selectedStatus) {
        [_selectImage setImage:[UIImage imageNamed:@"icon_letterSelected"]];
    }else{
        [_selectImage setImage:[UIImage imageNamed:@"icon_letterUnselected"]];
    }
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
