//
//  LoadingUtil.h
//  company
//
//  Created by Eugene on 16/8/11.
//  Copyright © 2016年 Eugene. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LoadingView.h"

@interface LoadingUtil : UIView

//单例
+(LoadingView*)shareInstance:(UIView*)view;

//单例
+(LoadingView*)shareInstance:(UIView *)view frame:(CGRect)frame;

//显示
+(void)showLoadingView:(UIView*)view;

//使用实例显示
+(void)showLoadingView:(UIView *)view withLoadingView:(LoadingView*)loadingView;

//关闭加载页
+(void)closeLoadingView:(LoadingView*)loadingView;

/**
 *
 *  加载视图
 *
 */
+(void)show:(LoadingView*)loadingView;

/**
 *
 *  关闭
 *
 */
+(void)close:(LoadingView*)loadingView;

@end
