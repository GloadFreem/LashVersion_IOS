//
//  InvestCommitProjectPCell.m
//  JinZhiT
//
//  Created by Eugene on 16/5/27.
//  Copyright © 2016年 Eugene. All rights reserved.
//

#import "InvestCommitProjectPCell.h"

@implementation InvestCommitProjectPCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    _iconImage.layer.cornerRadius = 29;
    _iconImage.layer.masksToBounds = YES;
    
}

-(void)setModel:(ProjectListProModel *)model
{
    _model = model;
    
    [_iconImage sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",model.startPageImage]] placeholderImage:[UIImage new]];
    //根据状态判断 状态图片
    if (!model.status) {
        _statusImage.hidden = YES;
    }
    if ([model.status isEqualToString:@"待路演"]) {
        _statusImage.image = [UIImage imageNamed:@"invest_noroad"];
    }
    if ([model.status isEqualToString:@"路演中"]) {
        _statusImage.image = [UIImage imageNamed:@"invest_roading"];
    }
    if ([model.status isEqualToString:@"预选"]) {
        _statusImage.image = [UIImage imageNamed:@"invest_yuxuan"];
    }
    
    _nameLabel.text = model.abbrevName;
    _companyLabel.text = model.fullName;
    _titleLabel.text = model.desc;
    
    _personNumLabel.text = [NSString stringWithFormat:@"%ld",(long)model.collectionCount];
    _moneyLabel.text = [NSString stringWithFormat:@"%ld",(long)model.financeTotal];
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
