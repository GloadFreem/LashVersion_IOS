//
//  self.m
//  WeiNI
//
//  Created by air on 14/11/20.
//  Copyright (c) 2014年 weini. All rights reserved.
//

#import "HttpUtils.h"
#import "TDUtil.h"

#import "NSString+SBJSON.h"
@implementation HttpUtils


- (void)getDataFromAPIWithOps:(NSString*)urlStr
        postParam:(NSDictionary*)postDic
        file:(NSString*)fileName
        postName:(NSString*)postName
        type:(NSInteger)type
        delegate:(id)delegate
        sel:(SEL)sel
{
    //网络请求地址
    NSURL* url = [NSURL URLWithString:[SERVICE_URL stringByAppendingString:urlStr]];
    NSLog(@"上传文件请求地址:%@",url); //用于测试
    
    //初始化ASIHttpRequest网络请求对象
    self.requestInstance=[ASIFormDataRequest requestWithURL:url];
    //设置超时时间
    [self.requestInstance setTimeOutSeconds:5];
    
    //将参数传入到Post 参数值
    if (postDic!=nil) {
        for (int i=0; i<postDic.count; i++) {
            NSString* key=[[postDic allKeys] objectAtIndex:i];
            NSString* value=[postDic valueForKey:key];
            [self.requestInstance setPostValue:value forKey:key];
        }
    }
    
    //获取图片在本地的完整路径
    NSString* filePath = [TDUtil loadContentPath:fileName];
    fileName = [fileName stringByAppendingString:@".jpg"];
    
    //设置上传参数
    [self.requestInstance setFile:filePath withFileName:fileName andContentType:@"jpg" forKey:@"file"];
    
    //设置请求模式
    [self setupWithType:type delegate:delegate sel:sel];
}

//使用字典上传图片
- (void)getDataFromAPIWithOps:(NSString*)urlStr
                    postParam:(NSDictionary*)postDic
                        files:(NSDictionary*) filesDic
                         type:(NSInteger)type
                     delegate:(id)delegate
                          sel:(SEL)sel
{
    
    NSURL* url = [NSURL URLWithString:[SERVICE_URL stringByAppendingString:urlStr]];
    NSLog(@"上传文件:%@",url);
    
    self.requestInstance=[ASIFormDataRequest requestWithURL:url];
    [self.requestInstance setTimeOutSeconds:5];
    [self.requestInstance setPostFormat:ASIMultipartFormDataPostFormat];
    if (postDic!=nil) {
        for (int i=0; i<postDic.count; i++) {
            NSString* key=[[postDic allKeys] objectAtIndex:i];
            NSString* value=[postDic valueForKey:key];
            [self.requestInstance setPostValue:value forKey:key];
        }
        [self.requestInstance setRequestMethod:@"POST"];
    }else{
        [self.requestInstance setRequestMethod:@"GET"];
    }
    
    NSString* fileName;
    NSArray * array = [filesDic allKeys];
    for (int i = 0 ; i <array.count; i++) {
        //上传用户名称
        fileName = [array objectAtIndex:i];
        //本地保存名称，用于获取本地存储路径
        NSString* filePath = [TDUtil loadContentPath:[filesDic valueForKey:fileName]];
        NSString * uploadFileName =[[filesDic valueForKey:fileName] stringByAppendingString:@".jpg"];
        
        [self.requestInstance setFile:filePath withFileName:uploadFileName andContentType:@"jpg" forKey:fileName];
    }
    
    //设置请求模式
    [self setupWithType:type delegate:delegate sel:sel];
    
}

//上传图片（数组）
- (void)getDataFromAPIWithOps:(NSString*)urlStr
                    postParam:(NSDictionary*)postDic
                         files:(NSMutableArray*)files
                     postName:(NSString*)postName
                         type:(NSInteger)type
                     delegate:(id)delegate
                          sel:(SEL)sel
{
    
    NSURL* url = [NSURL URLWithString:[SERVICE_URL stringByAppendingString:urlStr]];
//    NSLog(@"上传文件:%@",url);
    
    self.requestInstance=[ASIFormDataRequest requestWithURL:url];
    
    [self.requestInstance setPostFormat:ASIMultipartFormDataPostFormat];
    
    [self.requestInstance setTimeOutSeconds:5];
    if (postDic!=nil) {
        for (int i=0; i<postDic.count; i++) {
            NSString* key=[[postDic allKeys] objectAtIndex:i];
            NSString* value=[postDic valueForKey:key];
            [self.requestInstance setPostValue:value forKey:key];
        }
    }
    
    NSString* fileName;
    for (int i = 0 ; i <files.count; i++) {
        fileName = [files objectAtIndex:i];
        NSString* filePath = [TDUtil loadContentPath:fileName];
        fileName = [fileName stringByAppendingString:@".jpg"];
//        [self.requestInstance setFile:filePath withFileName:fileName andContentType:@"jpg" forKey:[NSString stringWithFormat:@"%@%d",postName,i]];
        
        UIImage * image = [TDUtil loadContent:[files objectAtIndex:i]];
//        NSData * imageData = UIImageJPEGRepresentation(image, 100);
        NSData * imageData = UIImagePNGRepresentation(image);
        [self.requestInstance addData:imageData withFileName:fileName andContentType:@"image/jpeg" forKey:@"images"];
        
    }
    
    //设置请求模式
    [self setupWithType:type delegate:delegate sel:sel];
    
}

- (void)getDataFromAPIWithOps:(NSString*)urlStr
        postParam:(NSDictionary*)postDic
        type:(NSInteger)type
        delegate:(id)delegate
        sel:(SEL)sel
{
    
    NSURL* url = [NSURL URLWithString:[SERVICE_URL stringByAppendingString:urlStr]];
    NSLog(@"请求地址:%@",url);
    
    self.requestInstance=[ASIFormDataRequest requestWithURL:url];
    [self.requestInstance setTimeOutSeconds:5];
    if (!postDic) {
        [self.requestInstance setRequestMethod:@"POST"];
    }
    
    if (postDic!=nil) {
        for (int i=0; i<postDic.count; i++) {
            NSString* key=[[postDic allKeys] objectAtIndex:i];
            NSString* value=[postDic valueForKey:key];
            [self.requestInstance setPostValue:value forKey:key];
        }
    }
    
    //设置请求模式
    [self setupWithType:type delegate:delegate sel:sel];
    
}

- (void)getDataFromYeePayAPIWithOps:(NSString*)urlStr
                    postParam:(NSDictionary*)postDic
                         type:(NSInteger)type
                     delegate:(id)delegate
                          sel:(SEL)sel
{
    
    NSURL* url = [NSURL URLWithString:[BUINESE_SERVERD stringByAppendingString:urlStr]];
    NSLog(@"请求地址:%@",url);
    
    self.requestInstance=[ASIFormDataRequest requestWithURL:url];
    [self.requestInstance setTimeOutSeconds:5];
    if (!postDic) {
        [self.requestInstance setRequestMethod:@"GET"];
    }
    if (postDic!=nil) {
        for (int i=0; i<postDic.count; i++) {
            NSString* key=[[postDic allKeys] objectAtIndex:i];
            NSString* value=[postDic valueForKey:key];
            [self.requestInstance setPostValue:value forKey:key];
        }
    }
    
    //设置请求模式
    [self setupWithType:type delegate:delegate sel:sel];
    
}


- (void)getDataFromAPI:(NSString*)urlStr
             postParam:(NSDictionary*)postDic
                  type:(NSInteger)type
              delegate:(id)delegate
{
    
    NSURL* url = [NSURL URLWithString:[SERVICE_URL stringByAppendingString:urlStr]];
    self.requestInstance=[ASIFormDataRequest requestWithURL:url];
    [self.requestInstance setTimeOutSeconds:5];
    if (!postDic) {
        [self.requestInstance setRequestMethod:@"GET"];
    }
    if (postDic!=nil) {
        for (int i=0; i<postDic.count; i++) {
            NSString* key=[[postDic allKeys] objectAtIndex:i];
            NSString* value=[postDic valueForKey:key];
            [self.requestInstance setPostValue:value forKey:key];
        }
    }
    self.requestInstance.timeOutSeconds=10;
   
    //设置请求模式
    [self setupWithType:type delegate:delegate sel:nil];
    
}



- (void)getDataFromAPIWithOps:(NSString *)urlStr
                         type:(NSInteger)type
                     delegate:(id)delegate
                          sel:(SEL)sel
                       method:(NSString *)method{
    
    NSURL* url = [NSURL URLWithString:[SERVICE_URL stringByAppendingString:urlStr]];
    NSLog(@"请求地址:%@",url);
    self.requestInstance=[ASIFormDataRequest requestWithURL:url];
    self.requestInstance.timeOutSeconds=5;
    [self.requestInstance setRequestMethod:method];
    
    //设置请求模式
    [self setupWithType:type delegate:delegate sel:sel];
    
}

/**
 *  ASIHttpRequest请求设置
 *
 *  @param type     同步、异步请求类型
 *  @param delegate 代理
 *  @param sel      请求成功后执行方法
 */
- (void) setupWithType:(NSInteger)type
              delegate:(id)delegate
                   sel:(SEL)sel
{
    
    if (delegate) {
        self.requestInstance.delegate=delegate;
    }else{
        self.requestInstance.delegate=self;
    }
    
    if (sel) {
        [self.requestInstance setDidFinishSelector:sel];
    }
    
    if (type==1) {
        [self.requestInstance startSynchronous];
    }else{
        [self.requestInstance startAsynchronous];
    }
    
}

/**
 *  释放空间
 */
- (void)dealloc {
    
    //在回收自身的时候，取消发出的请求，当然如果是多个request，可以都放到请求队列，一并撤销。
    [self.requestInstance cancel];
    [self.requestInstance setDelegate:nil];
}
@end
