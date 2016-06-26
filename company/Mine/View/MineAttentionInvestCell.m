//
//  MineAttentionInvestCell.m
//  JinZhiT
//
//  Created by Eugene on 16/5/23.
//  Copyright © 2016年 Eugene. All rights reserved.
//

#import "MineAttentionInvestCell.h"

@implementation MineAttentionInvestCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    _iconImage.layer.cornerRadius = 25.5;
    _iconImage.layer.masksToBounds = YES;
    
    for (UIButton *btn in _buttonArray) {
        btn.layer.cornerRadius = 3;
        btn.layer.masksToBounds = YES;
        btn.layer.borderColor = colorBlue.CGColor;
        btn.layer.borderWidth = 0.5;
    }
    
}

-(void)setModel:(MineCollectionListModel *)model
{
    _model = model;
    
    [_iconImage sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",model.headSculpture]] placeholderImage:[UIImage new]];
    _name.text = model.name;
    _position.text = model.position;
    //根据状态显示状态图片
    if ([model.status isEqualToString:@"投资人"]) {
        _statusImage.image = [UIImage imageNamed:@"invest_investperson"];
    }
    if ([model.status isEqualToString:@"投资机构"]) {
        _statusImage.image = [UIImage imageNamed:@"invest_organization"];
    }
    if ([model.status isEqualToString:@"智囊团"]) {
        _statusImage.image = [UIImage imageNamed:@"invest_thinkTank"];
    }
    
    _company.text = model.companyName;
    _address.text = model.companyAddress;
    
    //设置领域内容
    for (NSInteger i = model.areas.count; i < _buttonArray.count; i ++) {
        UIButton *btn = (UIButton*)_buttonArray[i];
        btn.hidden = YES;
    }
    //标题赋值
    for (NSInteger i = 0; i < model.areas.count; i ++) {
        UIButton *btn = (UIButton*)_buttonArray[i];
        [btn setTitle:[NSString stringWithFormat:@"%@",model.areas[i]] forState:UIControlStateNormal];
    }
    
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
