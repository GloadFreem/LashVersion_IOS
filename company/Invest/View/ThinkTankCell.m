//
//  ThinkTankCell.m
//  JinZhiT
//
//  Created by Eugene on 16/5/18.
//  Copyright © 2016年 Eugene. All rights reserved.
//

#import "ThinkTankCell.h"

@implementation ThinkTankCell

+ (instancetype)cellWithTableView:(UITableView *)tableView
{
    static NSString *ID = @"thinkTank";
    ThinkTankCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass(self) owner:nil options:nil] lastObject];
    }
    return cell;
}

-(void)setModel:(InvestListModel *)model
{
    _model = model;
    
    [_iconImage sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",model.headSculpture]] placeholderImage:[UIImage new]];
    
    _name.text = model.name;
    _position.text = model.position;
    _companyName.text = model.companyName;
    _companyAddress.text = model.companyAddress;
    _content.text = model.introduce;
    
    if (model.collected) {
        [_attentionBtn setTitle:[NSString stringWithFormat:@" 已关注"] forState:UIControlStateNormal];
        [_attentionBtn setBackgroundColor:btnCray];
    }else{
        [_attentionBtn setTitle:[NSString stringWithFormat:@" 关注(%ld)",(long)model.collectCount] forState:UIControlStateNormal];
        [_attentionBtn setBackgroundColor:btnGreen];
    }
    
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    _iconImage.layer.cornerRadius = 30;
    _iconImage.layer.masksToBounds = YES;
    _iconImage.layer.borderWidth = 0.5;
    _iconImage.layer.borderColor = color(224, 224, 224, 1).CGColor;
    
    _attentionBtn.layer.cornerRadius = 3;
    _attentionBtn.layer.masksToBounds = YES;
    
}
- (IBAction)attentionBtnClick:(UIButton *)sender {
    if ([self.delegate respondsToSelector:@selector(didClickAttentionBtnInCell:andModel:)]) {
        [self.delegate didClickAttentionBtnInCell:self andModel:_model];
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
