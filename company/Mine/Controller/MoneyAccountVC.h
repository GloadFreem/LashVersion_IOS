//
//  MoneyAccountVC.h
//  JinZhiT
//
//  Created by Eugene on 16/5/23.
//  Copyright © 2016年 Eugene. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MoneyAccountVC : RootViewController

@property (nonatomic, copy) NSString *profit;
@property (nonatomic, copy) NSString *borrowerUserNumber;
@property (nonatomic, copy) NSString *fullName;
@property (nonatomic, copy) NSString *abbrevName;

@property (nonatomic, strong) NSMutableDictionary *dataDict;

@end
