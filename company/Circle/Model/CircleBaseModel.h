//
//  CircleBaseModel.h
//  company
//
//  Created by Eugene on 16/6/10.
//  Copyright © 2016年 Eugene. All rights reserved.
//

#import <Foundation/Foundation.h>

#pragma makr -点赞内容点赞人模型
@interface CircleContentprisesUsersModel : NSObject

//头像
@property (nonatomic, copy) NSString *headSculpture;
//名字
@property (nonatomic, copy) NSString *name;
//userId
@property (nonatomic, copy) NSString *userId;

@end

#pragma mark -点赞内容模型
@interface CircleContentprisesContentModel : NSObject
//点赞人ID
@property (nonatomic, assign) NSInteger priseId;
//点赞人模型
@property (nonatomic, strong) CircleContentprisesUsersModel *users;

@end

#pragma mark -comment内容模型
@interface CircleUsersByAtUserIdModel : NSObject


//头像
@property (nonatomic, copy) NSString *headSculpture;
//名字
@property (nonatomic, copy) NSString *name;
//userId
@property (nonatomic, copy) NSString *userId;

@end

@interface CircleUsersByUserIdModel : NSObject

//头像
@property (nonatomic, copy) NSString *headSculpture;
//名字
@property (nonatomic, copy) NSString *name;
//userId
@property (nonatomic, copy) NSString *userId;

@end

#pragma mark -评论内容模型
//评论model
@interface CircleCommentsModel : NSObject
//评论id
@property (nonatomic, assign) NSInteger commentId;
//评论内容
@property (nonatomic, copy) NSString *content;
//
@property (nonatomic, strong) CircleUsersByAtUserIdModel *usersByAtUserId;
//
@property (nonatomic, strong) CircleUsersByUserIdModel *usersByUserId;
//发布时间
@property (nonatomic, copy) NSString *publicDate;
@end

#pragma mark -微博照片模型
@interface CircleContentimagesesModel : NSObject

@property (nonatomic, copy) NSString *url;

@end

#pragma mark -微博认证人城市省份模型
@interface CircleUsersAuthenticsCityProvinceModel :NSObject

@property (nonatomic, assign) BOOL isInvlid;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, assign) NSInteger provinceId;

@end

#pragma mark -微博认证人城市模型
@interface CircleUsersAuthenticsCityModel :NSObject

@property (nonatomic, assign) NSInteger cityId;
@property (nonatomic, assign) BOOL isInvlid;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, strong) CircleUsersAuthenticsCityProvinceModel *province;

@end

@interface CircleUsersAuthenticsIdentiytypeModel : NSObject

@property (nonatomic, copy) NSString *name;

@property (nonatomic, assign) NSInteger identiyTypeId;

@end

#pragma mark -发微博认证人模型
@interface CircleUsersAuthenticsModel : NSObject

@property (nonatomic, strong) CircleUsersAuthenticsCityModel *city;
@property (nonatomic, copy) NSString *companyAddress;
@property (nonatomic, copy) NSString *companyName;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *position;

@property (nonatomic, strong) CircleUsersAuthenticsIdentiytypeModel *identiytype;

@end

#pragma mark -发微博人信息模型
//发表人信息model
@interface CircleUsersModel : NSObject
//认证信息数组
@property (nonatomic, strong) NSArray *authentics;
//头像链接
@property (nonatomic, copy) NSString *headSculpture;
//名字
@property (nonatomic, copy) NSString *name;
//userId
@property (nonatomic, assign) NSInteger userId;

@end

@interface CircleFeeingtypeModel : NSObject

@property (nonatomic, copy) NSString *name;

@property (nonatomic, assign) NSInteger feelingTypeId;

@end

@interface CircleContenttypeModel : NSObject

@property (nonatomic, copy) NSString *name;
@property (nonatomic, assign) NSInteger typeId;

@end

@interface CircleContentshareModel : NSObject

@property (nonatomic, copy) NSString *desc;

@property (nonatomic, copy) NSString *content;

@property (nonatomic, copy) NSString *image;

@property (nonatomic, assign) NSInteger shareId;

@property (nonatomic, strong) CircleContenttypeModel *contenttype;

@end


@interface CircleBaseModel : NSObject
//评论数量
@property (nonatomic, assign) NSInteger commentCount;
//评论内容
@property (nonatomic, strong) NSArray *comments;
//微博内容
@property (nonatomic, copy ) NSString *content;
//微博照片数组
@property (nonatomic, strong) NSArray *contentimageses;
//点赞人数组
@property (nonatomic, strong) NSArray *contentprises;
//点赞数量
@property (nonatomic, assign) NSInteger priseCount;
//发布内容ID
@property (nonatomic, assign) NSInteger publicContentId;
//分享数量
@property (nonatomic, assign) NSInteger shareCount;
//微博发表人
@property (nonatomic, strong) CircleUsersModel *users;
//是否点赞
@property (nonatomic, assign) BOOL flag;
//发布时间
@property (nonatomic, copy) NSString *publicDate;

@property (nonatomic, strong) CircleFeeingtypeModel *feeingtype;

@property (nonatomic, strong) CircleContentshareModel *contentshare;

@end


