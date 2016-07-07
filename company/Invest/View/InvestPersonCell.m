//
//  InvestPersonCell.m
//  JinZhiT
//
//  Created by Eugene on 16/5/17.
//  Copyright © 2016年 Eugene. All rights reserved.
//

#import "InvestPersonCell.h"

@implementation InvestPersonCell


+ (instancetype)cellWithTableView:(UITableView *)tableView
{
    static NSString *ID = @"person";
    InvestPersonCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass(self) owner:nil options:nil] lastObject];
    }
    return cell;
}


- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    _iconImage.layer.cornerRadius = 30;
    _iconImage.layer.masksToBounds = YES;
    
    _leftBtn.layer.cornerRadius = 3;
    _leftBtn.layer.masksToBounds = YES;
    _leftBtn.layer.borderColor = colorBlue.CGColor;
    _leftBtn.layer.borderWidth = 0.5;
    
    _middleBtn.layer.cornerRadius = 3;
    _middleBtn.layer.masksToBounds = YES;
    _middleBtn.layer.borderColor = colorBlue.CGColor;
    _middleBtn.layer.borderWidth = 0.5;
    
    _rightBtn.layer.cornerRadius = 3;
    _rightBtn.layer.masksToBounds = YES;
    _rightBtn.layer.borderColor = colorBlue.CGColor;
    _rightBtn.layer.borderWidth = 0.5;
    
    _cimmitBtn.layer.cornerRadius = 3;
    _cimmitBtn.layer.masksToBounds = YES;
    
    _collectBtn.layer.cornerRadius = 3;
    _collectBtn.layer.masksToBounds = YES;
    
}

-(void)setModel:(InvestListModel *)model
{
    _model = model;
    
    [_iconImage sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",model.headSculpture]] placeholderImage:[UIImage new]];
    _name.text = model.name;
    _position.text = model.position;
    _companyName.text = model.companyName;
    _companyAddress.text = model.companyAddress;
    
    for (NSInteger i = model.areas.count; i < _btnArray.count; i ++) {
        UIButton *btn = (UIButton*)_btnArray[i];
        btn.hidden = YES;
    }
    //标题赋值
    for (NSInteger i = 0; i < model.areas.count; i ++) {
        UIButton *btn = (UIButton*)_btnArray[i];
        [btn setTitle:[NSString stringWithFormat:@"%@",model.areas[i]] forState:UIControlStateNormal];
    }
    
    if (model.commited) {
        [_cimmitBtn setTitle:[NSString stringWithFormat:@" 已提交"] forState:UIControlStateNormal];
        [_cimmitBtn setBackgroundColor:btnCray];//设置灰色背景
        [_cimmitBtn setUserInteractionEnabled:NO];
    }else{
        [_cimmitBtn setTitle:[NSString stringWithFormat:@" 提交项目"] forState:UIControlStateNormal];
        [_cimmitBtn setBackgroundColor:orangeColor];
        [_cimmitBtn setUserInteractionEnabled:YES];
    }
    if (model.collected) {
        [_collectBtn setTitle:[NSString stringWithFormat:@" 已关注"] forState:UIControlStateNormal];
        [_collectBtn setBackgroundColor:btnCray];
    }else{
    [_collectBtn setTitle:[NSString stringWithFormat:@" 关注(%ld)",(long)model.collectCount] forState:UIControlStateNormal];
        [_collectBtn setBackgroundColor:btnGreen];
    }
}

#pragma mark -提交按钮
- (IBAction)commitBtnClick:(UIButton *)sender {
    
    if ([self.delegate respondsToSelector:@selector(didClickCommitBtn:andModel:andIndexPath:)]) {
        [self.delegate didClickCommitBtn:self andModel:_model andIndexPath:_indexPath];
    }
}
#pragma mark -关注按钮
- (IBAction)attentionClick:(UIButton *)sender {
    if ([self.delegate respondsToSelector:@selector(didClickAttentionBtn:andModel:andIndexPath:)]) {
        [self.delegate didClickAttentionBtn:self andModel:_model andIndexPath:_indexPath];
    }
}




- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
