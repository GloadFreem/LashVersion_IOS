//
//  AppDelegate.h
//  company
//
//  Created by Eugene on 16/6/4.
//  Copyright © 2016年 Eugene. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JTabBarController.h"
#import "HttpUtils.h"
#import "DataBaseHelper.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) UINavigationController * nav;
@property (nonatomic, strong) JTabBarController * tabBar;
@property (nonatomic, copy) NSString *partner;
@property (nonatomic, copy) NSString *loginPartner;
@property(retain,nonatomic)HttpUtils* httpUtil; //网络请求对象

@property (nonatomic, assign) DataBaseHelper *dataBase;
@property (nonatomic, weak) Reachability  *hostReach;
@property (nonatomic, assign) BOOL netEnable;

-(void)createViewControllers;

@end

