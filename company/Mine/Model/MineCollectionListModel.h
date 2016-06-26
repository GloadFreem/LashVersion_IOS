//
//  MineCollectionListModel.h
//  company
//
//  Created by Eugene on 16/6/15.
//  Copyright © 2016年 Eugene. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MineCollectionListModel : NSObject

@property (nonatomic, copy) NSString *headSculpture;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *position;
@property (nonatomic, copy) NSString *identiyTypeId; //身份类型
@property (nonatomic, copy) NSString *companyName;
@property (nonatomic, copy) NSString *companyAddress;
@property (nonatomic, strong) NSArray *areas;  //领域
@property (nonatomic, assign) NSInteger userId;

@property (nonatomic, copy) NSString *status;
@end
