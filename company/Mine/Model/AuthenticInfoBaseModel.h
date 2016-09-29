//
//  AuthenticInfoBaseModel.h
//  company
//
//  Created by Eugene on 16/6/13.
//  Copyright © 2016年 Eugene. All rights reserved.
//

#import <Foundation/Foundation.h>


@class ProjectAuthentics,ProjectIdentiytype,ProjectAuthenticstatus,ProjectAuthenticCity,ProjectAuthenticProvince;
@interface AuthenticInfoBaseModel : NSObject

@property (nonatomic, strong) NSArray *areas;

@property (nonatomic, copy) NSString *telephone;

@property (nonatomic, assign) NSInteger userId;

@property (nonatomic, copy) NSString *headSculpture;

@property (nonatomic, strong) NSArray<ProjectAuthentics *> *authentics;


@end



@interface ProjectAuthentics : NSObject

@property (nonatomic, strong) ProjectAuthenticstatus *authenticstatus;

@property (nonatomic, copy) NSString *introduce;

@property (nonatomic, assign) NSInteger authId;

@property (nonatomic, copy) NSString *identiyCarA;

@property (nonatomic, copy) NSString *position;

@property (nonatomic, copy) NSString *optional;

@property (nonatomic, copy) NSString *companyAddress;

@property (nonatomic, strong) ProjectAuthenticCity *city;

@property (nonatomic, strong) ProjectIdentiytype *identiytype;

@property (nonatomic, copy) NSString *companyName;

@property (nonatomic, copy) NSString *name;

@property (nonatomic, copy) NSString *identiyCarNo;

@property (nonatomic, copy) NSString *companyIntroduce;

@property (nonatomic, copy) NSString *industoryArea;

@end

@interface ProjectIdentiytype : NSObject

@property (nonatomic, copy) NSString *name;

@property (nonatomic, assign) NSInteger identiyTypeId;

@end

@interface ProjectAuthenticstatus : NSObject

@property (nonatomic, assign) NSInteger statusId;

@property (nonatomic, copy) NSString *name;

@end

@interface ProjectAuthenticCity : NSObject

@property (nonatomic, assign) NSInteger cityId;

@property (nonatomic, assign) BOOL isInvlid;

@property (nonatomic, strong) ProjectAuthenticProvince *province;

@property (nonatomic, copy) NSString *name;

@end

@interface ProjectAuthenticProvince : NSObject

@property (nonatomic, copy) NSString *name;

@property (nonatomic, assign) NSInteger provinceId;

@property (nonatomic, assign) BOOL isInvlid;

@end

