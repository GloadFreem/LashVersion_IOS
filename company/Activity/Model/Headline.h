//
//  Headline.h
//  company
//
//  Created by LiLe on 16/8/24.
//  Copyright © 2016年 Eugene. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Headline : NSObject
/** 标题 */
@property (nonatomic, copy) NSString *name;
/** 信息类型 */
@property (nonatomic, copy) NSString *type;
/** 来源 */
@property (nonatomic, copy) NSString *source;
/** 日期 */
@property (nonatomic, copy) NSString *date;
/** 底部的图片 */
@property (nonatomic, copy) NSString *imgName;
/** 底部的图片 */
@property (nonatomic, copy) NSString *title;
/** 投条详情页面的链接 */
@property (nonatomic, copy) NSString *url;
/** 标记 */
@property (nonatomic, assign) NSInteger flag;
/** 记录的ID号 */
@property (nonatomic, assign) NSInteger recordId;


+ (instancetype)headlineWithDict:(NSDictionary *)dict;
- (instancetype)initWithDict:(NSDictionary *)dict;
@end
