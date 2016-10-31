//
//  EUNetWorkTool.h
//  LiveShow
//
//  Created by Eugene on 2016/10/13.
//  Copyright © 2016年 Eugene. All rights reserved.
//

#import <AFNetworking/AFNetworking.h>

typedef NS_ENUM(NSUInteger, NetworkStates) {
    NetworkStatesNone, // 没有网络
    NetworkStates2G, // 2G
    NetworkStates3G, // 3G
    NetworkStates4G, // 4G
    NetworkStatesWIFI // WIFI
};


@interface EUNetWorkTool : AFHTTPSessionManager

+ (instancetype)shareTool;

// 判断网络类型
+ (NetworkStates)getNetworkStates;


-(void)cancleRequest;
@end
