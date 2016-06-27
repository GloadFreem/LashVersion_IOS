//
//  MineAttentionInvestThinkTankCell.m
//  JinZhiT
//
//  Created by Eugene on 16/5/24.
//  Copyright © 2016年 Eugene. All rights reserved.
//

#import "MineAttentionInvestThinkTankCell.h"

@implementation MineAttentionInvestThinkTankCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    _icon.layer.cornerRadius = 25.5;
    _icon.layer.masksToBounds = YES;
    
    _introduce.layer.cornerRadius = 8;
    _introduce.layer.masksToBounds = YES;
    _introduce.layer.borderWidth = 0.5;
    _introduce.layer.borderColor = [UIColor greenColor].CGColor;

}

-(void)setModel:(MineCollectionListModel *)model
{
    _model = model;
    [_icon sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",model.headSculpture]] placeholderImage:[UIImage new]];
    _name.text = model.name;
    _position.text = model.position;
    _companyName.text = model.companyName;
    _address.text = model.companyName;
    _introduce.text = [NSString stringWithFormat:@"  %@  ",model.introduce];
    
    
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
