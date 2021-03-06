//
//  RootViewController.h
//  company
//
//  Created by Eugene on 16/6/4.
//  Copyright © 2016年 Eugene. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Reachability.h"
#import "HttpUtils.h"
#import "LoadingView.h"
#import "LoadingUtil.h"
#import "UITableViewCustomView.h"
#import "LoadingBlackView.h"
@interface RootViewController : UIViewController<LoadingViewDelegate>

@property (nonatomic, copy) NSString *partner;

@property(assign,nonatomic)int code;
@property(retain,nonatomic)NSString* content; //提示信息内容
@property(assign,nonatomic)BOOL startLoading; //是否开始加载
@property(assign,nonatomic)BOOL isTransparent; //是否透明显示全局视图
@property(retain,nonatomic)HttpUtils* httpUtil; //网络请求对象
@property(assign,nonatomic)BOOL isNetRequestError; //是否请求出错
@property(assign,nonatomic)CGRect loadingViewFrame; //自定义加载视图大小
@property(retain,nonatomic)NSMutableDictionary* dataDic; //字典数据
@property (assign, nonatomic) BOOL isBlack;   //黑色透明背景

@property (nonatomic, assign) BOOL online;
@property (nonatomic, assign) BOOL loginSucess;
@property (nonatomic, assign) BOOL loginFailed;

-(void)isOnline;
-(void)isAutoLogin;

- (void) refresh;  //刷新
- (void) resetLoadingView; //重置加载视图


#pragma mark--------从数据库加载数据-------------
-(NSArray*)getDataFromBaseTable:(NSString*)tableName;
#pragma mark-------保存数据------
-(void)saveDataToBaseTable:(NSString*)tableName data:(NSDictionary*)dic;

-(id)getOrgazinationDataFromBaseTable:(NSString*)tableName;
-(void)cancleRequest;


@end
