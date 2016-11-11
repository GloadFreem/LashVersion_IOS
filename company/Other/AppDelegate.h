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
#import "MyNavViewController.h"
@interface AppDelegate : UIResponder <UIApplicationDelegate,UITabBarControllerDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (nonatomic, strong) MyNavViewController *myNav;
@property (strong, nonatomic) UINavigationController * nav;
@property (nonatomic, strong) JTabBarController * tabBar;
@property (nonatomic, copy) NSString *partner;
@property (nonatomic, copy) NSString *loginPartner;
@property(retain,nonatomic)HttpUtils* httpUtil; //网络请求对象

@property (nonatomic, assign) DataBaseHelper *dataBase;
@property (nonatomic, weak) Reachability  *hostReach;
@property (nonatomic, assign) BOOL netEnable;

@property (nonatomic, assign) BOOL isActivity;

@property (nonatomic, assign) BOOL isLaunchedByNotification;

@end

