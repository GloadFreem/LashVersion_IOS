//
//  ActivityViewModel.h
//  company
//
//  Created by air on 16/06/14
//  Copyright (c) Eugene. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ActivityViewModel : NSObject
/** 图片的地址 */
@property (nonatomic, copy) NSString *imgUrl;
/** 地址 */
@property (nonatomic, copy) NSString *address;

@property (nonatomic, copy) NSString *endTime;

@property (nonatomic, assign) NSInteger memberLimit;

@property (nonatomic, copy) NSString *url;

@property (nonatomic, assign) NSInteger actionId;

@property (nonatomic, copy) NSString *desc;

@property (nonatomic, copy) NSString *startTime;

@property (nonatomic, copy) NSString *name;

@property (nonatomic, assign) NSInteger type;

@property (nonatomic, assign) Boolean flag;

@property (nonatomic, assign) Boolean attended;
/** 活动介绍数组 */
@property (nonatomic, strong) NSArray *actionintroduces;

@property (nonatomic, assign) Boolean isExpired;

- (instancetype)initWithDic:(NSDictionary *)dic;
+ (instancetype)activityViewModelWithDic:(NSDictionary *)dic;
@end
