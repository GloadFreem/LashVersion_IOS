//
//  ProjectViewController.h
//  JinZhiT
//
//  Created by Eugene on 16/5/3.
//  Copyright © 2016年 Eugene. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "noNetView.h"

@interface ProjectViewController : RootViewController<noNetViewDelegate>

@property (nonatomic, copy) NSString *loginPartner;
@property (nonatomic, strong) noNetView *netView;

//登录状态
@property (nonatomic, assign)BOOL hasLogin;
@property (nonatomic, assign) BOOL isSuccess;

@end
