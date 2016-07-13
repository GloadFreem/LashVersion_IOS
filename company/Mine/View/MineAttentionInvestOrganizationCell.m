//
//  MineAttentionInvestOrganizationCell.m
//  JinZhiT
//
//  Created by Eugene on 16/5/23.
//  Copyright © 2016年 Eugene. All rights reserved.
//

#import "MineAttentionInvestOrganizationCell.h"

@implementation MineAttentionInvestOrganizationCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    _icon.layer.cornerRadius = 25.5;
    _icon.layer.masksToBounds = YES;
    
    for (UIButton *btn in _btnArray) {
        btn.layer.cornerRadius = 3;
        btn.layer.masksToBounds = YES;
        btn.layer.borderColor = color(0, 160, 230, 1).CGColor;
        btn.layer.borderWidth = 0.5;
    }
}

-(void)setModel:(MineCollectionListModel *)model
{
    _model = model;
    
    [_icon sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",model.headSculpture]] placeholderImage:[UIImage new]];
    _name.text = model.name;
    _address.text = model.companyAddress;
    
    //设置领域内容
    for (NSInteger i = model.areas.count; i < _btnArray.count; i ++) {
        UIButton *btn = (UIButton*)_btnArray[i];
        btn.hidden = YES;
    }
    //标题赋值
    for (NSInteger i = 0; i < model.areas.count; i ++) {
        UIButton *btn = (UIButton*)_btnArray[i];
        [btn setTitle:[NSString stringWithFormat:@" %@ ",model.areas[i]] forState:UIControlStateNormal];
    }
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
