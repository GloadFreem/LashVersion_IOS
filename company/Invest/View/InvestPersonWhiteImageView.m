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
    
    _leftBtn.layer.cornerRadius = 3;
    _leftBtn.layer.masksToBounds = YES;
    
    _middleBtn.layer.cornerRadius = 3;
    _middleBtn.layer.masksToBounds = YES;
    
    _rightBtn.layer.cornerRadius = 3;
    _rightBtn.layer.masksToBounds = YES;
    
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
