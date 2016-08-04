//
//  InvestPersonWhiteImageView.m
//  JinZhiT
//
//  Created by Eugene on 16/5/18.
//  Copyright © 2016年 Eugene. All rights reserved.
//

#import "InvestPersonWhiteImageView.h"

@implementation InvestPersonWhiteImageView


#pragma mark- 实例化视图
+(InvestPersonWhiteImageView*)instancetationInvestPersonWhiteImageView
{
    InvestPersonWhiteImageView *view =[[[NSBundle mainBundle] loadNibNamed:@"InvestPersonWhiteImageView" owner:nil options:nil] lastObject];
    view.backgroundColor = [UIColor clearColor];
    return view;
}

-(void)awakeFromNib
{
    [super awakeFromNib];
    _iconImage.layer.cornerRadius = 47;
    _iconImage.layer.masksToBounds =YES;
    _iconImage.layer.borderWidth = 0.5;
    _iconImage.layer.borderColor = color(224, 224, 224, 1).CGColor;
    
    _leftBtn.layer.cornerRadius = 3;
    _leftBtn.layer.masksToBounds = YES;
    
    _middleBtn.layer.cornerRadius = 3;
    _middleBtn.layer.masksToBounds = YES;
    
    _rightBtn.layer.cornerRadius = 3;
    _rightBtn.layer.masksToBounds = YES;
    
    [_bottomLine setHidden:YES];
}

-(void)setAreas:(NSArray *)areas
{
    _areas = areas;
    
    if (areas.count == 1) {
        _leftBtn.hidden = YES;
        _rightBtn.hidden = YES;
        _middleBtn.hidden = NO;
        [_middleBtn setTitle:areas[0] forState:UIControlStateNormal];
        _middleBtnWidth.constant = 60;
    }
    if (areas.count == 2) {
        _leftBtn.hidden = NO;
        _rightBtn.hidden = NO;
        _middleBtn.hidden = YES;
        _middleBtnWidth.constant = 0.00000000001f;
        NSString *str = areas[0];
        if (str.length > 3) {
            _leftBtnWidth.constant = 70*WIDTHCONFIG;
        }else{
            _leftBtnWidth.constant = 50*WIDTHCONFIG;
        }
        [_leftBtn setTitle:str forState:UIControlStateNormal];
        [_rightBtn setTitle:areas[1] forState:UIControlStateNormal];
    }
    if (areas.count == 3) {
        _leftBtn.hidden = NO;
        _rightBtn.hidden = NO;
        _middleBtn.hidden = NO;
        _middleBtnWidth.constant = 60;
        NSString *str = areas[0];
        if (str.length > 3) {
            _leftBtnWidth.constant = 70*WIDTHCONFIG;
        }else{
            _leftBtnWidth.constant = 50*WIDTHCONFIG;
        }
        [_leftBtn setTitle:str forState:UIControlStateNormal];
        [_middleBtn setTitle:areas[1] forState:UIControlStateNormal];
        [_rightBtn setTitle:areas[2] forState:UIControlStateNormal];
    }
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
