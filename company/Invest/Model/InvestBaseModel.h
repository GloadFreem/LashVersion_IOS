//
//  InvestBaseModel.h
//  company
//
//  Created by Eugene on 16/6/14.
//  Copyright © 2016年 Eugene. All rights reserved.
//

#import <Foundation/Foundation.h>

@class User,Authentics,City,Province;

@interface InvestBaseModel : NSObject

@property (nonatomic, assign) BOOL collected;

@property (nonatomic, strong) User *user;

@property (nonatomic, strong) NSArray<NSString *> *areas;

@property (nonatomic, assign) BOOL commited;

@property (nonatomic, assign) NSInteger collectCount;

@end

@interface User : NSObject

@property (nonatomic, copy) NSString *wechatId;

@property (nonatomic, strong) NSArray<Authentics *> *authentics;

@property (nonatomic, copy) NSString *name;

@property (nonatomic, assign) NSInteger userId;

@property (nonatomic, copy) NSString *headSculpture;

@end


@interface Authentics : NSObject

@property (nonatomic, copy) NSString *introduce;

@property (nonatomic, strong) City *city;

@property (nonatomic, copy) NSString *position;

@property (nonatomic, copy) NSString *companyIntroduce;

@property (nonatomic, copy) NSString *industoryArea;

@property (nonatomic, copy) NSString *companyName;

@property (nonatomic, copy) NSString *companyAddress;

@property (nonatomic, copy) NSString *name;

@end


@interface City : NSObject

@property (nonatomic, assign) NSInteger cityId;

@property (nonatomic, assign) BOOL isInvlid;

@property (nonatomic, strong) Province *province;

@property (nonatomic, copy) NSString *name;

@end

@interface Province : NSObject

@property (nonatomic, copy) NSString *name;

@property (nonatomic, assign) NSInteger provinceId;

@property (nonatomic, assign) BOOL isInvlid;

@end

