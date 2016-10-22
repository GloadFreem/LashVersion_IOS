//
//  ThinkTankBaseModel.h
//  company
//
//  Created by Eugene on 16/6/14.
//  Copyright © 2016年 Eugene. All rights reserved.
//

#import <Foundation/Foundation.h>

@class ThinkUser,ThinkAuthentics,ThinkCity,ThinkProvince;
@interface ThinkTankBaseModel : NSObject



@property (nonatomic, assign) BOOL collected;

@property (nonatomic, strong) ThinkUser *user;

@property (nonatomic, strong) NSArray *areas;

@property (nonatomic, assign) BOOL commited;

@property (nonatomic, assign) NSInteger collectCount;

@end

@interface ThinkUser : NSObject

@property (nonatomic, assign) NSInteger userId;

@property (nonatomic, copy) NSString *headSculpture;

@property (nonatomic, copy) NSString *name;

@property (nonatomic, strong) NSArray<ThinkAuthentics *> *authentics;

@end

@interface ThinkAuthentics : NSObject

@property (nonatomic, copy) NSString *introduce;

@property (nonatomic, copy) NSString *companyIntroduce;

@property (nonatomic, copy) NSString *position;

@property (nonatomic, strong) ThinkCity *city;

@property (nonatomic, copy) NSString *companyName;

@property (nonatomic, copy) NSString *name;

@end

@interface ThinkCity : NSObject

@property (nonatomic, assign) NSInteger cityId;

@property (nonatomic, assign) BOOL isInvlid;

@property (nonatomic, strong) ThinkProvince *province;

@property (nonatomic, copy) NSString *name;

@end

@interface ThinkProvince : NSObject

@property (nonatomic, copy) NSString *name;

@property (nonatomic, assign) BOOL isInvlid;

@property (nonatomic, assign) NSInteger provinceId;

@end

