//
//  ProjectDetailLeftHeaderModel.h
//  JinZhiT
//
//  Created by Eugene on 16/6/1.
//  Copyright © 2016年 Eugene. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ProjectDetailLeftHeaderModel : NSObject


@property (nonatomic, copy) NSString *projectStr;

@property (nonatomic, copy) NSString *goalStr;
@property (nonatomic, copy) NSString *achieveStr;
@property (nonatomic, copy) NSString *timeStr;
@property (nonatomic, copy) NSString *addressStr;

@property (nonatomic, copy) NSString *statusStr;

@property (nonatomic, copy) NSString *content;
@property (nonatomic, strong) NSArray *pictureArray;

@property (nonatomic, assign) NSInteger financeTotal;

@property (nonatomic, assign) NSInteger financedMount;

@property (nonatomic, assign) BOOL isOpen;
@property (nonatomic, assign) BOOL shouldShowMoreButton;

@end
