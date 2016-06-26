//
//  InvestOrganizationBaseModel.h
//  company
//
//  Created by Eugene on 16/6/14.
//  Copyright © 2016年 Eugene. All rights reserved.
//

#import <Foundation/Foundation.h>

@class OrganizationInvestors,OrganizationUser,OrganizationAuthentics,OrganizationCity,OrganizationProvince,OrganizationFounddations;

@interface InvestOrganizationBaseModel : NSObject

@property (nonatomic, strong) NSArray<OrganizationInvestors *> *investors;

@property (nonatomic, strong) NSArray<OrganizationFounddations *> *founddations;

@end
@interface OrganizationInvestors : NSObject

@property (nonatomic, assign) BOOL collected;

@property (nonatomic, strong) OrganizationUser *user;

@property (nonatomic, strong) NSArray<NSString *> *areas;

@property (nonatomic, assign) BOOL commited;

@property (nonatomic, assign) NSInteger collectCount;

@end

@interface OrganizationUser : NSObject

@property (nonatomic, assign) NSInteger userId;

@property (nonatomic, copy) NSString *headSculpture;

@property (nonatomic, copy) NSString *name;

@property (nonatomic, strong) NSArray<OrganizationAuthentics *> *authentics;

@end

@interface OrganizationAuthentics : NSObject

@property (nonatomic, copy) NSString *companyIntroduce;

@property (nonatomic, strong) OrganizationCity *city;

@property (nonatomic, copy) NSString *introduce;

@property (nonatomic, copy) NSString *position;

@property (nonatomic, copy) NSString *industoryArea;

@property (nonatomic, copy) NSString *companyName;

@property (nonatomic, copy) NSString *companyAddress;

@property (nonatomic, copy) NSString *name;

@end

@interface OrganizationCity : NSObject

@property (nonatomic, assign) NSInteger cityId;

@property (nonatomic, assign) BOOL isInvlid;

@property (nonatomic, strong) OrganizationProvince *province;

@property (nonatomic, copy) NSString *name;

@end

@interface OrganizationProvince : NSObject

@property (nonatomic, copy) NSString *name;

@property (nonatomic, assign) BOOL isInvlid;

@property (nonatomic, assign) NSInteger provinceId;

@end

@interface OrganizationFounddations : NSObject

@property (nonatomic, assign) NSInteger foundationId;

@property (nonatomic, copy) NSString *content;

@property (nonatomic, copy) NSString *image;

@property (nonatomic, copy) NSString *name;

@property (nonatomic, copy) NSString *url;

@end

