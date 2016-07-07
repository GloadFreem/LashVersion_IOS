//
//  CircleListModel.h
//  JinZhiT
//
//  Created by Eugene on 16/5/26.
//  Copyright © 2016年 Eugene. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CircleListModel : NSObject

@property (nonatomic, copy) NSString *iconNameStr;   //头像
@property (nonatomic, copy) NSString *nameStr;       //名字
@property (nonatomic, copy) NSString *addressStr;    //地址
@property (nonatomic, copy) NSString *companyStr;    //公司
@property (nonatomic, copy) NSString *positionStr;   //职位
@property (nonatomic, copy) NSString *timeSTr;       //时间
@property (nonatomic, copy) NSString *msgContent;    //内容
@property (nonatomic, assign) NSInteger publicContentId; //帖子id
@property (nonatomic, assign) NSInteger shareCount;  //分享数量
@property (nonatomic, assign) NSInteger commentCount; //评论数量
@property (nonatomic, assign) NSInteger priseCount; //点赞数量
@property (nonatomic, copy) NSString *priseLabel;   //点赞人名字
@property (nonatomic, assign) BOOL flag;            //是否点赞

@property (nonatomic, assign) NSInteger userId;

@property (nonatomic, assign, getter = isLiked) BOOL liked;

@property (nonatomic, strong) NSArray *picNamesArray;    //
@property (nonatomic, assign) BOOL isOpening;
@property (nonatomic, assign ,readonly) BOOL shouldShowMoreBtn;


@end
