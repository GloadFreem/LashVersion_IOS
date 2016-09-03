//
//  UIButton+UIButtonImageWithLable.m
//  company
//
//  Created by LiLe on 16/8/20.
//  Copyright © 2016年 Eugene. All rights reserved.
//

#import "UIButton+UIButtonImageWithLable.h"

@implementation UIButton (UIButtonImageWithLable)
/*
// 左右
- (void)setImage:(UIImage *)image withTitle:(NSString *)title forState:(UIControlState)stateType {
    //UIEdgeInsetsMake(CGFloat top, CGFloat left, CGFloat bottom, CGFloat right)
    
    CGSize titleSize = [title sizeWithFont:(12.0f)];
    [self.imageView setContentMode:UIViewContentModeCenter];
    [self setImageEdgeInsets:UIEdgeInsetsMake(-8.0,
                                              0.0,
                                              0.0,
                                              -titleSize.width)];
    [self setImage:image forState:stateType];
    
    [self.titleLabel setContentMode:UIViewContentModeCenter];
    [self.titleLabel setBackgroundColor:[UIColor clearColor]];
    [self.titleLabel setFont:HELVETICANEUEMEDIUM_FONT(12.0f)];
    [self.titleLabel setTextColor:COLOR_ffffff];
    [self setTitleEdgeInsets:UIEdgeInsetsMake(30.0,
                                              -image.size.width,
                                              0.0,
                                              0.0)];
    [self setTitle:title forState:stateType];
}
 */

// 上下
+ (UIButton *)setImageWithName:(NSString *)imageName withTitle:(NSString *)title forState:(UIControlState)stateType {
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn.imageView setContentMode:UIViewContentModeCenter];
    [btn setImageEdgeInsets:UIEdgeInsetsMake(1.0,
                                             0.0,
                                             0.0,
                                             10.0)];
    [btn setImage:[UIImage imageNamed:imageName] forState:stateType];
    
    [btn.titleLabel setContentMode:UIViewContentModeCenter];
    [btn.titleLabel setBackgroundColor:[UIColor clearColor]];
    [btn.titleLabel setFont:[UIFont systemFontOfSize:19.0f]];
    [btn.titleLabel setTextColor:[UIColor grayColor]];
    [btn setTitleEdgeInsets:UIEdgeInsetsMake(6.0,
                                             0.0,
                                             0.0,
                                             0.0)];
    [btn setTitle:title forState:stateType];
    
    [btn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    btn.backgroundColor = [UIColor whiteColor];
    return btn;
}


@end
