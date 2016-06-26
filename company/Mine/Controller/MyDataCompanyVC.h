//
//  MyDataCompanyVC.h
//  JinZhiT
//
//  Created by Eugene on 16/5/25.
//  Copyright © 2016年 Eugene. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MineDataVC.h"

@interface MyDataCompanyVC : RootViewController

@property (nonatomic, strong) MineDataVC *datavc;

@property (nonatomic, copy) NSString *titleName;
@property (nonatomic, copy) NSString *type;
@property (nonatomic, copy) NSString *placorText;

@end
