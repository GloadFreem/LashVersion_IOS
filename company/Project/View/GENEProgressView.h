//
//  GENEProgressView.h
//  company
//
//  Created by Eugene on 16/7/2.
//  Copyright © 2016年 Eugene. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GENEProgressView : UIView

/**
 *  构造方法
 *
 *  @param lineColor 线的颜色
 *  @param loopColor 圆环颜色
 */
-(instancetype)initWithLineColor:(UIColor*)lineColor
                       loopColor:(UIColor*)loopColor;
/**
 *  进度
 */
@property (nonatomic,assign)CGFloat percent;
/**
 *  进度字体颜色
 */
@property (nonatomic,strong)UIColor* percentColor;
/**
 *  进度的单位，例如 % 、分 、‰ 默认为空
 */
@property (nonatomic,copy)NSString* percentUnit;

/**
 *  线颜色，默认橘色
 */
@property (nonatomic,strong)UIColor* lineColor;
/**
 *  圆环颜色，默认绿色
 */
@property (nonatomic,strong)UIColor *loopColor;

/**
 *  是否执行动画
 */
@property (nonatomic,assign,getter=isAnimatable)BOOL animatable;
/**
 *  标题
 */
@property (nonatomic,copy)NSString* title;
/**
 *  标题颜色
 */
@property (nonatomic,strong)UIColor *titleColor;

/**
 *  圈内显示内容
 */
@property (nonatomic, copy) NSString *contentText;

@end
