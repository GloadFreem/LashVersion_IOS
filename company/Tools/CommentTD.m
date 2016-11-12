//
//  CommentTD.m
//  company
//
//  Created by Eugene on 16/7/28.
//  Copyright © 2016年 Eugene. All rights reserved.
//

#import "CommentTD.h"

#define LOGINUSER @"isLoginUser"
#define DENGLU @"loginUser"

@implementation CommentTD


-(BOOL)isOnline
{
    NSString *partner = [TDUtil encryKeyWithMD5:KEY action:LOGINUSER];
    NSDictionary *dic =[NSDictionary dictionaryWithObjectsAndKeys:KEY,@"key",partner,@"partner", nil];
    
//    LYJWeakSelf;
    //开始请求
    [[EUNetWorkTool shareTool] POST:JZT_URL(ISLOGINUSER) parameters:dic progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSDictionary *dic = responseObject;
        if ([dic[@"status"] intValue]== 200){
//            weakSelf.isOnline = YES;
//            return;
        }else{
//            weakSelf.isOnline = NO;
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
//        weakSelf.isOnline = NO;
    }];
//    if (_isOnline) {
//        return YES;
//    }
    return NO;
}

-(BOOL)autoLogin
{
    //获取缓存数据
    NSUserDefaults* data = [NSUserDefaults standardUserDefaults];
    NSString *phoneNumber = [data valueForKey:STATIC_USER_DEFAULT_DISPATCH_PHONE];
    NSString *password = [data valueForKey:STATIC_USER_PASSWORD];
    //激光推送Id
    NSString *regId = [JPUSHService registrationID];
    
    NSString * string = [AES encrypt:DENGLU password:KEY];
    NSString *partner = [TDUtil encryptMD5String:string];
    NSDictionary *dic = [[NSDictionary alloc]initWithObjectsAndKeys:KEY,@"key",partner,@"partner",phoneNumber,@"telephone",password,@"password",PLATFORM,@"platform", regId,@"regId",nil];
    LYJWeakSelf;
    [[EUNetWorkTool shareTool] POST:JZT_URL(USER_LOGIN) parameters:dic progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if ([dic[@"status"] intValue]== 200){
            weakSelf.loginSucess = YES;
        }else{
            weakSelf.loginSucess = NO;
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            weakSelf.loginSucess = NO;
    }];
    
    return NO;
}
@end
