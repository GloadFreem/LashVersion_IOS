//
//  LQQMonitorKeyboard.h
//  监听键盘弹出消失
//
//  Created by Artron_LQQ on 16/2/20.
//  Copyright © 2016年 Artup. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void(^LQQBlock)(NSInteger height);
@interface LQQMonitorKeyboard : NSObject

/**
 *  @author LQQ, 16-02-20 17:02:02
 *
 *  移除监察者,控制器跳转的时候调用一下就行,也可不用调用
 */
+(void)LQQRemoveMonitor;


/**
 *  @author LQQ, 16-02-20 17:02:47
 *
 *  添加监听键盘弹出或消失方法,
 *
 *  @param showBackBlock 键盘 弹出的回调block,可带动画效果
 *  @param dismissBackBlock 键盘 消失的回调block,带动画效果
 */
+(void)LQQAddMonitorWithShowBack:(LQQBlock)showBackBlock andDismissBlock:(LQQBlock)dismissBackBlock;
@end
