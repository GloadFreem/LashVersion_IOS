//
//  ProjectListProModel.h
//  company
//
//  Created by Eugene on 16/6/15.
//  Copyright © 2016年 Eugene. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ProjectListProModel : NSObject


@property (nonatomic, copy) NSString *desc;

@property (nonatomic, copy) NSString *startPageImage;
@property (nonatomic, copy) NSString *abbrevName;
@property (nonatomic, copy) NSString *address;
@property (nonatomic, copy) NSString *fullName;
@property (nonatomic, copy) NSString *status;
@property (nonatomic, assign) NSInteger collectionCount;
@property (nonatomic, copy) NSString *endDate;
@property (nonatomic, assign) NSInteger financeTotal; //融资总额
@property (nonatomic, assign) NSInteger financedMount; //已融金额
@property (nonatomic, assign) NSInteger projectId; 

@property (nonatomic, strong) NSArray *areas;

@end
