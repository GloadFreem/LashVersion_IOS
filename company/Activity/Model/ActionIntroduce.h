//
//  ActionIntroduce.h
//  company
//
//  Created by LiLe on 16/8/24.
//  Copyright © 2016年 Eugene. All rights reserved.
//  活动介绍模型

#import <Foundation/Foundation.h>

@interface ActionIntroduce : NSObject
/** 序号 */
@property (nonatomic, assign) NSInteger introduceId;
/** 类型：0为文字，1为图片 */
@property (nonatomic, assign) NSInteger type;
/** 文字内容或图片链接 */
@property (nonatomic, copy) NSString *content;

- (instancetype)initWithDic:(NSDictionary *)dic;
+ (instancetype)ActionIntroducesWithDic:(NSDictionary *)dic;

@end
