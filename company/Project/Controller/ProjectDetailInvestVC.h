//
//  ProjectDetailInvestVC.h
//  JinZhiT
//
//  Created by Eugene on 16/6/2.
//  Copyright © 2016年 Eugene. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AuthenticInfoBaseModel.h"
@interface ProjectDetailInvestVC : RootViewController

@property (nonatomic, copy) NSString *profit;

@property (nonatomic, assign) float limitAmount;
@property (nonatomic, assign) NSInteger projectId;
@property (nonatomic, copy) NSString *borrowerUserNumber;
@property (nonatomic, strong) AuthenticInfoBaseModel *authenticModel;
@property (nonatomic, copy) NSString *fullName;
@property (nonatomic, copy) NSString *abbrevName;
@property (nonatomic, copy) NSString *startPageImage;

@end
