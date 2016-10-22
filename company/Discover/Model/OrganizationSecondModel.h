//
//  OrganizationSecondModel.h
//  company
//
//  Created by Eugene on 16/6/14.
//  Copyright © 2016年 Eugene. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface OrganizationSecondModel : NSObject

@property (nonatomic, copy) NSString *headSculpture;
@property (nonatomic, copy) NSString *companyName;
@property (nonatomic, copy) NSString *companyAddress;
@property (nonatomic, assign) NSInteger collectCount; //关注数量
@property (nonatomic, assign) BOOL collected; //是否关注
@property (nonatomic, assign) BOOL commited;
@property (nonatomic, strong) NSArray<NSString *> *areas;
@property (nonatomic, copy) NSString *userId;

@end
