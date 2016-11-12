//
//  CommentTD.h
//  company
//
//  Created by Eugene on 16/7/28.
//  Copyright © 2016年 Eugene. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CommentTD : NSObject

@property (nonatomic, assign) BOOL online;
@property (nonatomic, assign) BOOL loginSucess;
/**
 *    判断是否在线
 */
+(BOOL)isOnline;

/**
 *    自动登录
 */
+(BOOL)autoLogin;

@end
