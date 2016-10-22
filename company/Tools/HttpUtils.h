//
//  HttpUtils.h
//  WeiNI
//
//  Created by air on 14/11/20.
//  Copyright (c) 2014年 weini. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ASIFormDataRequest.h"

@interface HttpUtils : NSObject<ASIHTTPRequestDelegate>

@property(retain,nonatomic)ASIFormDataRequest* requestInstance;  //请求实例

/**
 *  用于进行常规网络代理请求
 *
 *  @param urlStr   请求网络地址
 *  @param postDic  传入字典参数
 *  @param type     请求类型，0:同步请求，1:异步请求
 *  @param delegate 代理
 */
-(void)getDataFromAPI:(NSString*)urlStr
            postParam:(NSDictionary*)postDic
                 type:(NSInteger)type
             delegate:(id)delegate;

/**
 *
 *  用于进行定制返回代理方法
 *  @param urlStr   请求网络地址
 *  @param postDic  传入字典参数
 *  @param type     请求类型，0:同步请求，1:异步请求
 *  @param delegate 代理
 *  @param sel      网络请求成功后执行方法
 */
-(void)getDataFromAPIWithOps:(NSString*)urlStr
                   postParam:(NSDictionary*)postDic
                        type:(NSInteger)type
                    delegate:(id)delegate
                         sel:(SEL)sel;

- (void)getThinkDataFromAPIWithOps:(NSString*)urlStr
                         postParam:(NSDictionary*)postDic
                              type:(NSInteger)type
                          delegate:(id)delegate
                               sel:(SEL)sel;
/**
 *
 *  用于进行易宝定制返回代理方法
 *  @param urlStr   请求网络地址
 *  @param postDic  传入字典参数
 *  @param type     请求类型，0:同步请求，1:异步请求
 *  @param delegate 代理
 *  @param sel      网络请求成功后执行方法
 */
-(void)getDataFromYeePayAPIWithOps:(NSString*)urlStr
                   postParam:(NSDictionary*)postDic
                        type:(NSInteger)type
                    delegate:(id)delegate
                         sel:(SEL)sel;

/**
 *
 *  用于进行无参数传递网络请求
 *  @param urlStr   请求网络地址
 *  @param type     请求类型，0:同步请求，1:异步请求
 *  @param delegate 代理
 *  @param sel      网络请求方式 "GET" "POST"
 */
-(void)getDataFromAPIWithOps:(NSString*)urlStr
                        type:(NSInteger)type
                    delegate:(id)delegate
                         sel:(SEL)sel
                      method:(NSString*)method;

/**
 *
 *  用于上传单张图片
 *  @param urlStr   请求网络地址
 *  @param postDic  传入字典参数
 *  @param fileName     图片本地路径名称
 *  @param postName     上传至服务器时显示名称，用于服务器端用该名称获取Data
 *  @param type     请求类型，0:同步请求，1:异步请求
 *  @param delegate 代理
 *  @param sel      网络请求成功后执行方法
 */
-(void)getDataFromAPIWithOps:(NSString*)urlStr
                   postParam:(NSDictionary*)postDic
                        file:(NSString*)fileName
                    postName:(NSString*)postName
                        type:(NSInteger)type
                    delegate:(id)delegate
                         sel:(SEL)sel;

/**
 *  用于进行多文件上传
 *
 *  @param urlStr   请求网络地址
 *  @param postDic  传入字典参数
 *  @param files    文件数组
 *  @param postName 上传至服务器时显示名称，用于服务器端用该名称获取Data
 *  @param type     请求类型，0:同步请求，1:异步请求
 *  @param delegate 代理
 *  @param sel      网络请求成功后执行方法
 */
- (void)getDataFromAPIWithOps:(NSString*)urlStr
                    postParam:(NSDictionary*)postDic
                        files:(NSMutableArray*)files
                     postName:(NSString*)postName
                         type:(NSInteger)type
                     delegate:(id)delegate
                          sel:(SEL)sel;

/**
 *  使用字典存储 key: 接口所需文件名称，value:本地存储文件名称，用于获取文件在本地路径
 *
 *  @param urlStr   请求地址
 *  @param postDic  传参数
 *  @param filesDic 文件字典
 *  @param type     网络请求类型
 *  @param delegate 代理
 *  @param sel      执行方法
 */
- (void)getDataFromAPIWithOps:(NSString*)urlStr
                    postParam:(NSDictionary*)postDic
                        files:(NSDictionary*) filesDic
                         type:(NSInteger)type
                     delegate:(id)delegate
                          sel:(SEL)sel;

/**
 *  释放空间
 */

- (void)requestDealloc;

@end
