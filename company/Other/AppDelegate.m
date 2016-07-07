//
//  AppDelegate.m
//  company
//
//  Created by Eugene on 16/6/4.
//  Copyright © 2016年 Eugene. All rights reserved.
//

#import "AppDelegate.h"
#import "ProjectViewController.h"
#import "InvestViewController.h"
#import "MineViewController.h"
#import "CircleViewController.h"
#import "ActivityViewController.h"
#import "LoginRegistViewController.h"
#import "RegisterViewController.h"
#import "SetPassWordViewController.h"
#import "MyNavViewController.h"

#import "GuidePageViewController.h"

#import "JPUSHService.h"
#import "IQKeyboardManager.h"

#import "UMSocial.h"

#import "UMSocialWechatHandler.h"
#import "UMSocialQQHandler.h"

#define DENGLU @"loginUser"
#define LOGINUSER @"isLoginUser"
#define UmengAppkey @"55c7684de0f55a0d0d0042a8"
@interface AppDelegate ()
{
    BOOL isSuccess;
    BOOL isLogin;
}


@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    _window = [[UIWindow alloc]initWithFrame:[UIScreen mainScreen].bounds];
    _window.backgroundColor = [UIColor whiteColor];
    [self createViewControllers];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent animated:NO];
    
    [NSThread sleepForTimeInterval:2];
    
    //获取缓存数据
    NSUserDefaults* data = [NSUserDefaults standardUserDefaults];
    NSString* isStart= [data valueForKey:@"isStart"];
    NSString *phoneNumber = [data valueForKey:STATIC_USER_DEFAULT_DISPATCH_PHONE];
    NSString *password = [data valueForKey:STATIC_USER_PASSWORD];
    //激光推送Id
    NSString *regId = [JPUSHService registrationID];
    self.httpUtil = [[HttpUtils alloc]init];
    
    [self isLogin];
    
    if (isStart && [isStart isEqualToString:@"true"]) {
        if (isLogin)
        {
            [_window setRootViewController:_tabBar];
            
        }else{
            
            if (phoneNumber && password)
            {
                NSString * string = [AES encrypt:DENGLU password:KEY];
                self.partner = [TDUtil encryptMD5String:string];
                NSDictionary *dic = [[NSDictionary alloc]initWithObjectsAndKeys:KEY,@"key",self.partner,@"partner",phoneNumber,@"telephone",password,@"password",PLATFORM,@"platform", regId,@"regId",nil];
                //开始请求
                [self.httpUtil getDataFromAPIWithOps:USER_LOGIN postParam:dic type:1 delegate:self sel:@selector(requestLogin:)];
                if (isSuccess)
                {
                    
                    [_window setRootViewController:_tabBar];
                }else{
                    LoginRegistViewController * login = [[LoginRegistViewController alloc]init];
                    
                    self.nav = [[UINavigationController alloc]initWithRootViewController:login];
                    [_window setRootViewController:self.nav];
                }
            }else{
                LoginRegistViewController * login = [[LoginRegistViewController alloc]init];
                
                self.nav = [[UINavigationController alloc]initWithRootViewController:login];
                [_window setRootViewController:self.nav];
                
            }
        }

    }else{
        GuidePageViewController *vc = [GuidePageViewController new];
        self.nav = [[UINavigationController alloc]initWithRootViewController:vc];
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
    if ([[UIDevice currentDevice].systemVersion floatValue] >= 8.0) {
        //       categories
        [JPUSHService registerForRemoteNotificationTypes:(UIUserNotificationTypeBadge |
                                                          UIUserNotificationTypeSound |
                                                          UIUserNotificationTypeAlert)
                                              categories:nil];
    }else {
        //categories    nil
        [JPUSHService registerForRemoteNotificationTypes:(UIRemoteNotificationTypeBadge |
                                                UIRemoteNotificationTypeSound |
                                                UIRemoteNotificationTypeAlert)
                                              categories:nil];
    }
    
    [JPUSHService setupWithOption:launchOptions appKey:@"cc3fdb255d49497c5fd3d402"
                          channel:@"Publish channel"
                 apsForProduction:@"1"];
    
    
    //向微信注册
    [WXApi registerApp:@"wx33aa0167f6a81dac" withDescription:@"jinzht"];
    
#pragma mark --0---=-----友盟分享
    //设置友盟社会化组件appkey
    [UMSocialData setAppKey:UmengAppkey];
    [UMSocialQQHandler setSupportWebView:NO];
    
    [UMSocialWechatHandler setWXAppId:@"wx33aa0167f6a81dac" appSecret:@"bc5e2b89553589bf7d9e568545793842" url:@"http://www.umeng.com/social"];
    [UMSocialQQHandler setQQWithAppId:@"1104722649" appKey:@"fvSYiMZrQvetGolT" url:@"http://www.umeng.com/social"];
    return YES;
}

-(void) onResp:(BaseResp*)resp
{
//    NSString *strMsg = [NSString stringWithFormat:@"errcode:%d", resp.errCode];
//    NSString *strTitle;
    
//    if([resp isKindOfClass:[SendMessageToWXResp class]])
//    {
//        strTitle = [NSString stringWithFormat:@"金指投温馨提示"];
//        if(resp.errCode==-2){
//            strMsg=@"分享已取消";
//        }else if(resp.errCode==0){
//            strMsg=@"分享成功";
//        }
//        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:strTitle message:strMsg delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
//        [alert show];
//    }else{
        SendAuthResp *aresp = (SendAuthResp *)resp;
        if (aresp.errCode== 0) {
            NSString *code = aresp.code;
            NSDictionary *dic = @{@"code":code};
            NSLog(@"%@",dic);
        }
//    }
}


-(void)requestLogin:(ASIHTTPRequest *)request
{
    NSString *jsonString = [TDUtil convertGBKDataToUTF8String:request.responseData];
//    NSLog(@"返回:%@",jsonString);
    NSMutableDictionary* jsonDic = [jsonString JSONValue];
    
    if (jsonDic!=nil) {
        NSString *status = [jsonDic valueForKey:@"status"];
        if ([status intValue] == 200) {
//            NSLog(@"登陆成功");
            isSuccess = YES;
            
            NSUserDefaults* data =[NSUserDefaults standardUserDefaults];
            
            [data setValue:[jsonDic[@"data"] valueForKey:@"userId"] forKey:USER_STATIC_USER_ID];
            [data setValue:[jsonDic[@"data"] valueForKey:@"extUserId"] forKey:USER_STATIC_EXT_USER_ID];
            
        }else{
            
            
        }
        
    }
    
}

-(void)isLogin
{
    _loginPartner = [TDUtil encryKeyWithMD5:KEY action:LOGINUSER];
    NSDictionary *dic =[NSDictionary dictionaryWithObjectsAndKeys:KEY,@"key",self.loginPartner,@"partner", nil];
    //开始请求
    [self.httpUtil getDataFromAPIWithOps:ISLOGINUSER postParam:dic type:1 delegate:self sel:@selector(requestIsLogin:)];
    
}
-(void)requestIsLogin:(ASIHTTPRequest *)request
{
    NSString *jsonString = [TDUtil convertGBKDataToUTF8String:request.responseData];
//    NSLog(@"返回:%@",jsonString);
    NSMutableDictionary* jsonDic = [jsonString JSONValue];
    
    if (jsonDic!=nil) {
        NSString *status = [jsonDic valueForKey:@"status"];
        if ([status intValue] == 200) {
//            NSLog(@"登陆成功");
            isLogin = YES;
            
        }
    }
}

//-(BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url
//{
//    NSLog(@"%@",url.host);
//    //return [WXApi handleOpenURL:url delegate:self];
//    return [TencentOAuth HandleOpenURL:url] ||
//    [WXApi handleOpenURL:url delegate:self] ;
//}

//-(BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation
//{
//    NSLog(@"%@",url.host);
//    if ([sourceApplication isEqualToString:@"com.apple.mobilesafari"] || [sourceApplication isEqualToString:@"com.apple.MobileSMS"]) {
//        if ([url.host containsString:@"project"] || [url.host containsString:@"projectId"] || [url.host containsString:@"projectDetail"]) {
//            NSArray *array = [[NSString stringWithFormat:@"%@",url] componentsSeparatedByString:@"/"]; //从字符A中分隔成2个元素的数组
//            id obj = array[array.count-2];
//            if ((NSInteger)obj) {
//                NSInteger index = [obj integerValue];
//                [self loadProjectDetail:index];
//            }
//        }else{
//            NSString * urlStr = [[NSString stringWithFormat:@"%@",url] stringByReplacingOccurrencesOfString:@"jinzht://" withString:@""];
//            [self loadWebViewDetail:[NSURL URLWithString:urlStr]];
//        }
//        return true;
//    }else{
//        return [TencentOAuth HandleOpenURL:url] || [WXApi handleOpenURL:url delegate:self];
//    }
//}

#pragma mark - 创建主界面框架
-(void)createViewControllers{
    NSMutableArray * unSelectedArray = [[NSMutableArray alloc]initWithObjects:[UIImage imageNamed:@"project.png"],[UIImage imageNamed:@"invest.png"],[UIImage imageNamed:@"Circle.png"],[UIImage imageNamed:@"activity.png"],nil];
    
    NSMutableArray * selectedArray = [[NSMutableArray alloc]initWithObjects:[UIImage imageNamed:@"project_selected .png"],[UIImage imageNamed:@"invest_selected.png"],[UIImage imageNamed:@"Circle_selected.png"], [UIImage imageNamed:@"activity_selected.png"],nil];
    
    NSMutableArray * titles = [[NSMutableArray alloc]initWithObjects:@"项目",@"投资人",@"圈子",@"活动", nil];
    
    ProjectViewController * project = [[ProjectViewController alloc]init];
    MyNavViewController * navProject = [[MyNavViewController alloc]initWithRootViewController:project];
    
    InvestViewController * invest = [[InvestViewController alloc]init];
    MyNavViewController * navInvest = [[MyNavViewController alloc]initWithRootViewController:invest];
    
    CircleViewController * circle =[[CircleViewController alloc]init];
    MyNavViewController * navCircle =[[MyNavViewController alloc]initWithRootViewController:circle];
    
    ActivityViewController * activity = [[ActivityViewController alloc]init];
    MyNavViewController * navActivity = [[MyNavViewController alloc]initWithRootViewController:activity];
    
    self.tabBar = [[JTabBarController alloc]initWithTabBarSelectedImages:selectedArray normalImages:unSelectedArray titles:titles];
    self.tabBar.showCenterItem = YES;
    self.tabBar.centerItemImage = [UIImage imageNamed:@"mine.png"];
    self.tabBar.viewControllers = @[navProject,navInvest,navCircle,navActivity];
    self.tabBar.textColor = orangeColor;
    MyNavViewController *navMine = [[MyNavViewController alloc]initWithRootViewController:[[MineViewController alloc]init]];
    self.tabBar.centerViewController = navMine;
    
}

#pragma mark -push

- (void)application:(UIApplication *)application
didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    /// Required -    DeviceToken
    [JPUSHService registerDeviceToken:deviceToken];
}
- (void)application:(UIApplication *)application didReceiveRemoteNotification:
(NSDictionary *)userInfo {
    // Required,For systems with less than or equal to iOS6
    [JPUSHService handleRemoteNotification:userInfo];
}
- (void)application:(UIApplication *)application didReceiveRemoteNotification:
(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler {
    // IOS 7 Support Required
    [JPUSHService handleRemoteNotification:userInfo];
    completionHandler(UIBackgroundFetchResultNewData);
}

#pragma mark ---------友盟

- (BOOL)application:(UIApplication *)application
      handleOpenURL:(NSURL *)url
{
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

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
