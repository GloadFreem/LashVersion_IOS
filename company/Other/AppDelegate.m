//
//  AppDelegate.m
//  company
//
//  Created by Eugene on 16/6/4.
//  Copyright © 2016年 Eugene. All rights reserved.
//

#import "AppDelegate.h"

#import "GDataXMLNode.h"

#import "DataBaseHelper.h"
#import "DiscoverViewController.h"

#import "ProjectViewController.h"
#import "InvestViewController.h"
#import "MineViewController.h"
#import "CircleViewController.h"
#import "ActivityViewController.h"
#import "LoginRegistViewController.h"
#import "RegisterViewController.h"
#import "SetPassWordViewController.h"
#import "MyNavViewController.h"
#import "ActivityViewModel.h"
#import "GuidePageViewController.h"

//#import "JPUSHService.h"
#import "JPUSHService.h"
#import <UserNotifications/UserNotifications.h>

#import "IQKeyboardManager.h"

#import "UMSocial.h"
#import "MobClick.h"

#import "UMSocialWechatHandler.h"
#import "UMSocialQQHandler.h"
//#import "PingTaiWebViewController.h"
#import "ProjectBannerDetailVC.h"
#import "ProjectDetailController.h"
#import "ProjectLetterViewController.h"
#import "TankViewController.h"
#define DENGLU @"loginUser"
#define LOGINUSER @"isLoginUser"
#define UmengAppkey @"55c7684de0f55a0d0d0042a8"


@interface AppDelegate ()<JPUSHRegisterDelegate>
{
    BOOL isSuccess;
    BOOL isLogin;
}


@end

@implementation AppDelegate

static NSString * const JPUSHAPPKEY = @"cc3fdb255d49497c5fd3d402"; // 极光appKey
static NSString * const channel = @"Publish channel"; // 固定的

#ifdef DEBUG // 开发

static BOOL const isProduction = FALSE; // 极光FALSE为开发环境

#else // 生产

static BOOL const isProduction = TRUE; // 极光TRUE为生产环境

#endif


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    _window = [[UIWindow alloc]initWithFrame:[UIScreen mainScreen].bounds];
    _window.backgroundColor = [UIColor whiteColor];
//    _myNav = [[MyNavViewController alloc] init];
    _tabBar = [[JTabBarController alloc] init];
    _tabBar.delegate = self;
    
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent animated:NO];
    //创建数据库
    [self createTable];
    
    // 监测网络情况
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(netStatusChanged:)
                                                 name: kReachabilityChangedNotification
                                               object: nil];
    
    self.hostReach = [Reachability reachabilityForInternetConnection];
    [_hostReach startNotifier];
    [self updateInterfaceWithReachability:_hostReach];
    
    //获取缓存数据
    NSUserDefaults* data = [NSUserDefaults standardUserDefaults];
    NSString* isStart= [data valueForKey:@"isStart"];
    NSString *phoneNumber = [data valueForKey:STATIC_USER_DEFAULT_DISPATCH_PHONE];
    NSString *password = [data valueForKey:STATIC_USER_PASSWORD];
    //激光推送Id
//    NSString *regId = [JPUSHService registrationID];
    
    self.httpUtil = [[HttpUtils alloc]init];
    
    if (isStart && [isStart isEqualToString:@"true"]){
        
        if (phoneNumber && password)
        {
//            self.nav = [[UINavigationController alloc]initWithRootViewController:_tabBar];
//            [self.nav setNavigationBarHidden:YES];
//            self.nav.navigationBar.hidden = YES;
            [_window setRootViewController:_tabBar];
        }else{
            LoginRegistViewController * login = [[LoginRegistViewController alloc]init];
            self.nav = [[UINavigationController alloc]initWithRootViewController:login];
//            [self.nav setNavigationBarHidden:YES];
            [_window setRootViewController:self.nav];
        }
    }else{
        GuidePageViewController *vc = [GuidePageViewController new];
        self.nav = [[UINavigationController alloc]initWithRootViewController:vc];
//        [self.nav setNavigationBarHidden:YES];
        [_window setRootViewController:self.nav];
    }

    [_window makeKeyAndVisible];
    
    //设置键盘防遮挡输入框
    IQKeyboardManager *manager = [IQKeyboardManager sharedManager];
    manager.enable = YES;
    manager.shouldResignOnTouchOutside = YES;
    manager.shouldToolbarUsesTextFieldTintColor = YES;
    manager.enableAutoToolbar = YES;
    
#pragma mark --------- 激光推送
    LYJWeakSelf;
    //Required
    if ([[UIDevice currentDevice].systemVersion floatValue] >= 10.0) {
        JPUSHRegisterEntity * entity = [[JPUSHRegisterEntity alloc] init];
        entity.types = UNAuthorizationOptionAlert|UNAuthorizationOptionBadge|UNAuthorizationOptionSound;

        [JPUSHService registerForRemoteNotificationConfig:entity delegate:weakSelf];
    }
    else if ([[UIDevice currentDevice].systemVersion floatValue] >= 8.0) {
        //可以添加自定义categories
        [JPUSHService registerForRemoteNotificationTypes:(UIUserNotificationTypeBadge |
                                                          UIUserNotificationTypeSound |
                                                          UIUserNotificationTypeAlert)
                                              categories:nil];
    }
    else {//8.0以下不支持app
        //categories 必须为nil
        [JPUSHService registerForRemoteNotificationTypes:(UIRemoteNotificationTypeBadge |
                                                UIRemoteNotificationTypeSound |
                                                UIRemoteNotificationTypeAlert)
                                              categories:nil];
    }

    [JPUSHService setupWithOption:launchOptions appKey:JPUSHAPPKEY
                          channel:channel
                 apsForProduction:isProduction
            advertisingIdentifier:nil];
    
    //2.1.9版本新增获取registration id block接口。
    [JPUSHService registrationIDCompletionHandler:^(int resCode, NSString *registrationID) {
        if(resCode == 0)
        {
            // iOS10获取registrationID放到这里了, 可以存到缓存里, 用来标识用户单独发送推送
            NSLog(@"registrationID获取成功：%@",registrationID);
            [[NSUserDefaults standardUserDefaults] setObject:registrationID forKey:@"registrationID"];
            [[NSUserDefaults standardUserDefaults] synchronize];
        }
        else
        {
            NSLog(@"registrationID获取失败，code：%d",resCode);
        }
    }];
    
//    // apn 内容获取：
//    NSDictionary *remoteNotification = [launchOptions objectForKey: UIApplicationLaunchOptionsRemoteNotificationKey];
//    NSLog(@"打印字段---%@",remoteNotification);
//    if (remoteNotification != nil) {
//        [self notification:remoteNotification];
//    }
    
    [[UIApplication sharedApplication] setApplicationIconBadgeNumber:0];
    //向微信注册
    [WXApi registerApp:@"wx33aa0167f6a81dac" withDescription:@"jinzht"];
    
#pragma mark --0---=-----友盟分享
    //设置友盟社会化组件appkey
    [UMSocialData setAppKey:UmengAppkey];
    [UMSocialQQHandler setSupportWebView:NO];
    
    [UMSocialWechatHandler setWXAppId:@"wx33aa0167f6a81dac" appSecret:@"bc5e2b89553589bf7d9e568545793842" url:@"http://www.umeng.com/social"];
    [UMSocialQQHandler setQQWithAppId:@"1104722649" appKey:@"fvSYiMZrQvetGolT" url:@"http://www.umeng.com/social"];
    
    //友盟统计
    [MobClick startWithAppkey:UmengAppkey reportPolicy:BATCH channelId:nil];
    
    return YES;
}


- (void)updateInterfaceWithReachability:(Reachability *)reachability
{
    NetworkStatus netStatus = [reachability currentReachabilityStatus];
    switch (netStatus) {
        case NotReachable:
//            NSLog(@"====当前网络状态不可达=======http://www.cnblogs.com/xiaofeixiang");
            //网络不可用通知
        [[NSNotificationCenter defaultCenter] postNotificationName:@"netNotEnable" object:nil userInfo:nil];
            break;
        case ReachableViaWiFi:
//            NSLog(@"====当前网络状态为Wifi=======博客园-Fly_Elephant");
        case ReachableViaWWAN:
//            NSLog(@"====当前网络状态为3G=======keso");
            //网络可用通知
        [[NSNotificationCenter defaultCenter] postNotificationName:@"netEnable" object:nil userInfo:nil];
            
            break;
    }
}

-(void)netStatusChanged:(NSNotification*)noti
{
    Reachability* curReach = [noti object];
    NSParameterAssert([curReach isKindOfClass:[Reachability class]]);
    [self updateInterfaceWithReachability:curReach];
    
}

#pragma mark- JPUSHRegisterDelegate
//注册APNs成功并上报DeviceToken
- (void)application:(UIApplication *)application
didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    /// Required -    DeviceToken
    [JPUSHService registerDeviceToken:deviceToken];
}

//实现注册APNs失败接口（可选
-(void)application:(UIApplication*)application didFailToRegisterForRemoteNotificationsWithError:(nonnull NSError *)error
{
    //Optional
    NSLog(@"did Fail To Register For Remote Notifications With Error: %@", error);
}



// iOS 10 Support
- (void)jpushNotificationCenter:(UNUserNotificationCenter *)center willPresentNotification:(UNNotification *)notification withCompletionHandler:(void (^)(NSInteger))completionHandler {
    // Required
    NSDictionary * userInfo = notification.request.content.userInfo;
    NSLog(@"ioS10推送---%@",userInfo);
    if([notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
        [JPUSHService handleRemoteNotification:userInfo];
        
    }else{
        NSLog(@"本地通知");
    }
    
    if (([UIApplication sharedApplication].applicationState == UIApplicationStateActive)) {
        _isActivity = YES;
        [self notification:userInfo];
        NSLog(@"前台运行");
        //            return;
    }
    
    if (([UIApplication sharedApplication].applicationState == UIApplicationStateBackground)) {
        NSLog(@"后台运行");
    }
    if (([UIApplication sharedApplication].applicationState == UIApplicationStateInactive)) {
        NSLog(@"未运行");
    }
    
    completionHandler(UNNotificationPresentationOptionAlert); // 需要执行这个方法，选择是否提醒用户，有Badge、Sound、Alert三种类型可以选择设置
}

// iOS 10 Support
- (void)jpushNotificationCenter:(UNUserNotificationCenter *)center didReceiveNotificationResponse:(UNNotificationResponse *)response withCompletionHandler:(void (^)())completionHandler {
    // Required
    NSDictionary * userInfo = response.notification.request.content.userInfo;
    NSLog(@"ioS10推送222---%@",userInfo);
    if([response.notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
        [JPUSHService handleRemoteNotification:userInfo];
        
//        NSString *message = [NSString stringWithFormat:@"did%@", [userInfo[@"aps"] objectForKey:@"alert"]];
//        NSLog(@"iOS10程序关闭后通过点击推送进入程序弹出的通知: %@", message);
//        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:message delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil, nil];
//        [alert show];
        
        [self notification:userInfo];
        
    }else{
        NSLog(@"本地通知");
    }
    [self notification:userInfo];
    completionHandler();  // 系统要求执行这个方法
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:
(NSDictionary *)userInfo {
    // Required,For systems with less than or equal to iOS6
    [JPUSHService handleRemoteNotification:userInfo];
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:
(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler {
    // IOS 7 Support Required
    //前台运行
//    if ([UIApplication sharedApplication].applicationState == UIApplicationStateActive) {
//        [self notification:userInfo];
//    }else{
//        [self notification:userInfo];
//    }
    [self notification:userInfo];
    completionHandler(UIBackgroundFetchResultNewData);
    
}

-(void)notification:(NSDictionary*)userInfo
{
    NSString * type = [userInfo valueForKey:@"type"];
    UIViewController * controller;
    NSDictionary * notificationDic;
    
    if ([type isEqualToString:@"web"]) {
        controller = [[ProjectBannerDetailVC alloc]init];
        ((ProjectBannerDetailVC*)controller).url = [userInfo valueForKey:@"content"];
        ((ProjectBannerDetailVC*)controller).titleStr = [userInfo valueForKey:@"title"];
        ((ProjectBannerDetailVC*)controller).contentText = [userInfo valueForKey:@"share_content"];
        ((ProjectBannerDetailVC*)controller).image = [userInfo valueForKey:@"share_img_url"];
        ((ProjectBannerDetailVC*)controller).titleText = [userInfo valueForKey:@"title"];
        notificationDic = [NSDictionary dictionaryWithObjectsAndKeys:controller,@"controller",@"消息推送",@"title", nil];
        ((ProjectBannerDetailVC*)controller).isPush = YES;
        controller.hidesBottomBarWhenPushed = YES;
//        UIViewController *vc = [self getPresentedViewController];
//        
        if (!_myNav) {
            _myNav = [_tabBar childViewControllers][0];
        }
//
//        if (vc) {
//            _nav = (MyNavViewController *)vc;
//        }
//        
        [_myNav pushViewController:controller animated:YES];
//        _window.rootViewController = controller;
        
    }else if ([type isEqualToString:@"project"]) {
        
        controller = [[ProjectDetailController alloc]init];
        ((ProjectDetailController*)controller).projectId = [[userInfo valueForKey:@"content"] integerValue];
        
        notificationDic = [NSDictionary dictionaryWithObjectsAndKeys:controller,@"controller",[userInfo valueForKey:@"ext"],@"title", nil];
        
    }else if ([type isEqualToString:@"action"]) {

    }else{
        controller = [[ProjectLetterViewController alloc]init];
        notificationDic = [NSDictionary dictionaryWithObjectsAndKeys:controller,@"controller",[userInfo valueForKey:@"ext"],@"title", nil];
        [[NSNotificationCenter defaultCenter]postNotificationName:@"setLetterStatus" object:nil];
    }
    
    [[NSNotificationCenter defaultCenter]postNotificationName:@"pushController" object:nil userInfo:notificationDic];
    [JPUSHService handleRemoteNotification:userInfo];
    [UIApplication sharedApplication].applicationIconBadgeNumber =0;
}

- (void)tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController
{
    //    NSLog(@"选择器");
    //    [self getPresentedViewController];
    _myNav =(MyNavViewController *) viewController;
//    NSLog(@"打印选择控制器---%@",[viewController class]);
}
-(BOOL)tabBarController:(UITabBarController *)tabBarController shouldSelectViewController:(UIViewController *)viewController
{
    
    if ([tabBarController.childViewControllers indexOfObject:viewController] == tabBarController.childViewControllers.count - 3) {
        MineViewController *mine = [[MineViewController alloc]init];
        MyNavViewController *navVc = [[MyNavViewController alloc]initWithRootViewController:mine];
        //选择显示界面
        [tabBarController presentViewController:navVc animated:YES completion:nil];
        _myNav = navVc;
//        NSLog(@"推出的控制器---%@",[navVc class]);
        return NO;
    }
    return YES;
}

#pragma mark ---------友盟

- (BOOL)application:(UIApplication *)application
      handleOpenURL:(NSURL *)url
{
    return [UMSocialSnsService handleOpenURL:url];
}

-(BOOL)application:(UIApplication *)application openURL:(NSURL *)url options:(nonnull NSDictionary<NSString *,id> *)options{
    return [UMSocialSnsService handleOpenURL:url];
}

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation
{
    BOOL result = [UMSocialSnsService handleOpenURL:url];
    if (result == FALSE) {
        //调用其他SDK，例如支付宝SDK等
        
    }
    return result;
}

#pragma mark-------------------------数据库-------------------------
-(void)createTable
{
    _dataBase = [DataBaseHelper sharedInstance];
    
    [self checkUpTable:BANNERTABLE];
    
    [self checkUpTable:PROJECTTABLE];
    
    [self checkUpTable:ROADTABLE];
    
    [self checkUpTable:INVESTPERSONTABLE];
    
    [self checkUpTable:INVESTORGANIZATIONTABLE];
    
//    [self checkUpTable:INVESTORGANIZATIONSECONDTABLE];
    
    [self checkUpTable:THINKTANKTABLE];
    
    [self checkUpTable:CIRCLETABLE];
    
    [self checkUpTable:ACTIVITYTABLE];
    
}

-(void)checkUpTable:(NSString*)tableName
{
    if ([_dataBase isExistWithTableName:tableName]) {
//        NSLog(@"%@表存在",tableName);
        //        [dataBase dropTable:ACTIVITYTABLE];
    }else{
        BOOL ret = [_dataBase createTableWithTableName:tableName keys:@[@"data"]];
        if (ret) {
//            NSLog(@"%@创建成功",tableName);
        }else{
//            NSLog(@"%@创建失败",tableName);
        }
    }
}
- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    [application setApplicationIconBadgeNumber:0];
    NSLog(@"进入后台");
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    [application setApplicationIconBadgeNumber:0];
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
