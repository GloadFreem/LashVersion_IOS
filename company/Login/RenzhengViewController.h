//
//  RenzhengViewController.h
//  JinZhiT
//
//  Created by Eugene on 16/5/6.
//  Copyright © 2016年 Eugene. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RenzhengViewController : UIViewController

@property (nonatomic, copy) NSString *identifyType;
@property (nonatomic, copy) NSString *identiyCarNo;
@property (nonatomic, copy) NSString *companyAddress;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *companyName;
@property (nonatomic, copy) NSString *position;
@property (nonatomic, copy) NSString *investField;

@property (nonatomic, copy) NSString *cityId;
@property (nonatomic, copy) NSString *areaId;


@property (nonatomic, strong) NSMutableDictionary *dataDic; //数据字典

-(void)refreshData;

@end
