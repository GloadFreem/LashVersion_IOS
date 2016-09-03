//
//  UIButton+UIButtonImageWithLable.h
//  company
//
//  Created by LiLe on 16/8/20.
//  Copyright © 2016年 Eugene. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIButton (UIButtonImageWithLable)

+ (UIButton *)setImageWithName:(NSString *)imageName withTitle:(NSString *)title forState:(UIControlState)stateType;

@end
