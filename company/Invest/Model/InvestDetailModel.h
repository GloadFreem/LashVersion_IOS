//
//  InvestDetailModel.h
//  company
//
//  Created by Eugene on 16/6/14.
//  Copyright © 2016年 Eugene. All rights reserved.
//

#import <Foundation/Foundation.h>

@class DetailUser,DetailAuthentics,DetailCity,DetailProvince;

@interface InvestDetailModel : NSObject



@property (nonatomic, strong) NSArray<NSString *> *areas;

@property (nonatomic, assign) NSInteger collectCount;
@property (nonatomic, assign) BOOL collected;
@property (nonatomic, assign) BOOL commited;

@property (nonatomic, strong) DetailUser *user;


@end
@interface DetailUser : NSObject

@property (nonatomic, strong) NSArray<DetailAuthentics *> *authentics;

@property (nonatomic, copy) NSString *name;

@property (nonatomic, assign) NSInteger userId;

@property (nonatomic, copy) NSString *headSculpture;

@property (nonatomic, assign) NSInteger extUserId;

@property (nonatomic, copy) NSString *regId;

@property (nonatomic, copy) NSString *wechatId;
@end

@interface DetailAuthentics : NSObject

@property (nonatomic, copy) NSString *introduce;

@property (nonatomic, strong) DetailCity *city;

@property (nonatomic, copy) NSString *position;

@property (nonatomic, copy) NSString *companyIntroduce;

@property (nonatomic, copy) NSString *industoryArea;

@property (nonatomic, copy) NSString *companyName;

@property (nonatomic, copy) NSString *companyAddress;

@property (nonatomic, copy) NSString *name;

@end

@interface DetailCity : NSObject

@property (nonatomic, assign) NSInteger cityId;

@property (nonatomic, assign) BOOL isInvlid;

@property (nonatomic, strong) DetailProvince *province;

@property (nonatomic, copy) NSString *name;

@end

@interface DetailProvince : NSObject

@property (nonatomic, copy) NSString *name;

@property (nonatomic, assign) NSInteger provinceId;

@property (nonatomic, assign) BOOL isInvlid;

@end

