//
//  ProjectNoRoadCell.m
//  JinZhiT
//
//  Created by Eugene on 16/5/9.
//  Copyright © 2016年 Eugene. All rights reserved.
//

#import "ProjectNoRoadCell.h"

@implementation ProjectNoRoadCell

- (void)awakeFromNib {
    // Initialization code
    [super awakeFromNib];
    
    _iconImage.layer.cornerRadius = 30;
    _iconImage.layer.masksToBounds = YES;
    _iconImage.layer.borderWidth = 0.5;
    _iconImage.layer.borderColor = color(224, 224, 224, 1).CGColor;
    
    _leftBtn.layer.cornerRadius = 3;
    _leftBtn.layer.masksToBounds = YES;
    _leftBtn.layer.borderWidth = 0.5;
    _leftBtn.layer.borderColor = colorBlue.CGColor;
    
    _middleBtn.layer.cornerRadius = 3;
    _middleBtn.layer.masksToBounds = YES;
    _middleBtn.layer.borderWidth = 0.5;
    _middleBtn.layer.borderColor = colorBlue.CGColor;
    
    _rightBtn.layer.cornerRadius = 3;
    _rightBtn.layer.masksToBounds = YES;
    _rightBtn.layer.borderWidth = 0.5;
    _rightBtn.layer.borderColor = colorBlue.CGColor;
    
    UIImageView *imagePoint = [UIImageView new];
    imagePoint.image = [UIImage imageNamed:@"image-point.png"];
    imagePoint.size = imagePoint.image.size;
    imagePoint.x = _pointLabel.x;
    imagePoint.y = _pointLabel.y + 4;
    [self.contentView addSubview:imagePoint];
    _pointLabel.hidden = YES;
//    [imagePoint mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.right.mas_equalTo(self.contentView.mas_right).offset(-20);
//    }];
}

-(void)setModel:(ProjectListProModel *)model
{
    _model = model;
    
    [_iconImage sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",model.startPageImage]] placeholderImage:[UIImage imageNamed:@"placeholderIcon"]];
    _projectLabel.text = model.abbrevName;
    _companyLabel.text = model.fullName;
    
    for (NSInteger i = model.areas.count; i < _btnArray.count; i ++) {
        UIButton *btn = (UIButton*)_btnArray[i];
        btn.hidden = YES;
    }
    for (NSInteger i = 0; i < model.areas.count; i ++) {
        UIButton *btn = (UIButton*)_btnArray[i];
        [btn setTitle:[NSString stringWithFormat:@" %@ ",model.areas[i]] forState:UIControlStateNormal];
    }
    _personNumLabel.text = [NSString stringWithFormat:@"%ld",(long)model.collectionCount];
    _moneyLabel.text = [NSString stringWithFormat:@"%ld万",(long)model.financeTotal];
    
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
