//
//  NSString+Addition.h
//  
//
//  Created on 15/9/1.
//  Copyright (c) 2015年 LSY. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@interface NSString (Addition)

/**
 计算单行行宽
 */
- (CGFloat)commonStringWidthForFont:(CGFloat)fontSize;

/**
 计算行高
*/
- (CGFloat)commonStringHeighforLabelWidth:(CGFloat)width withFontSize:(CGFloat)fontSize;

/**
 计算文本最后一个字坐标点,需输入Label的frame值
 */
- (CGPoint)commonStringLastPointWithLabelFrame:(CGRect)frame withFontSize:(CGFloat)fontSize;
/**
 正则表达式判断
 */

- (BOOL)isUserName;

- (BOOL)isPassword;

- (BOOL)isEmail;

- (BOOL)isUrl;

- (BOOL)isTelephone;

- (BOOL) isEmpty;
-(BOOL) isidentityCard;
/**
 *  在文本中间添加横划线
 *
 *  @param text
 *
 *  @return NSMutableAttributedString
 */
- (NSMutableAttributedString *)addTextCenterLine;


//纯数字
- (BOOL)isNumber;

/// 十六进制转换为普通字符串
+ (NSString *)stringFromHexString:(NSString *)hexString;
/// 普通字符串转换为十六进制
+ (NSString *)hexStringFromString:(NSString *)string;
/// 判断是否为表情
+ (BOOL)stringIsTureContainsEmoji:(NSString *)string;

@end
