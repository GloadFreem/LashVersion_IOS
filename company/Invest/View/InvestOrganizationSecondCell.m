//
//  InvestOrganizationSecondCell.m
//  JinZhiT
//
//  Created by Eugene on 16/5/17.
//  Copyright © 2016年 Eugene. All rights reserved.
//

#import "InvestOrganizationSecondCell.h"

@implementation InvestOrganizationSecondCell

+ (instancetype)cellWithTableView:(UITableView *)tableView
{
    static NSString *ID = @"organizationSecond";
    InvestOrganizationSecondCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass(self) owner:nil options:nil] lastObject];
    }
    return cell;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    _iconImage.layer.cornerRadius = 32.5;
    _iconImage.layer.masksToBounds = YES;
    
    _firstLabel.layer.cornerRadius = 3;
    _firstLabel.layer.masksToBounds = YES;
    _firstLabel.layer.borderColor = colorBlue.CGColor;
    _firstLabel.layer.borderWidth = 0.5;
    
    _secondLabel.layer.cornerRadius = 3;
    _secondLabel.layer.masksToBounds = YES;
    _secondLabel.layer.borderColor = colorBlue.CGColor;
    _secondLabel.layer.borderWidth = 0.5;
    
    _thirdLabel.layer.cornerRadius = 3;
    _thirdLabel.layer.masksToBounds = YES;
    _thirdLabel.layer.borderColor = colorBlue.CGColor;
    _thirdLabel.layer.borderWidth = 0.5;
    
    _commitBtn.layer.cornerRadius =3;
    _commitBtn.layer.masksToBounds = YES;
    
    _attentionBtn.layer.cornerRadius =3;
    _attentionBtn.layer.masksToBounds = YES;
    
}

-(void)setModel:(InvestListModel *)model
{
    _model = model;
    [_iconImage sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",model.headSculpture]] placeholderImage:[UIImage new]];
    _name.text = model.companyName;
    _address.text = model.companyAddress;
    
    //隐藏多余的
    for (NSInteger i = model.areas.count; i < _labelArray.count; i ++) {
        UILabel *label = (UILabel *)_labelArray[i];
        label.hidden = YES;
    }
    //标题赋值
    for (NSInteger i = 0; i < model.areas.count; i ++) {
        UILabel *label = (UILabel*)_labelArray[i];
        label.text = model.areas[i];
    }
    
    if (model.commited) {
        [_commitBtn setTitle:[NSString stringWithFormat:@" 已提交"] forState:UIControlStateNormal];
        [_commitBtn setBackgroundColor:color(255, 103, 0, 1)];//设置灰色背景
        [_commitBtn setUserInteractionEnabled:NO];
    }else{
        [_commitBtn setTitle:[NSString stringWithFormat:@" 提交项目"] forState:UIControlStateNormal];
        [_commitBtn setBackgroundColor:orangeColor];
    }
    
    if (model.collected) {
        [_attentionBtn setTitle:[NSString stringWithFormat:@" 已关注"] forState:UIControlStateNormal];
        [_attentionBtn setBackgroundColor:btnCray];
    }else{
        [_attentionBtn setTitle:[NSString stringWithFormat:@" 关注(%ld)",(long)model.collectCount] forState:UIControlStateNormal];
        [_attentionBtn setBackgroundColor:btnGreen];
    }
}

- (IBAction)commitBtnClick:(UIButton *)sender {
    
    if ([self.delegate respondsToSelector:@selector(didClickCommitBtn:andModel:)]) {
        [self.delegate didClickCommitBtn:self andModel:_model];
    }
}
- (IBAction)attentionBtnClick:(UIButton *)sender {
    if ([self.delegate respondsToSelector:@selector(didClickAttentionBtn:andModel:)]) {
        [self.delegate didClickAttentionBtn:self andModel:_model];
    }
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
