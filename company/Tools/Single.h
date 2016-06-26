//
//  Single.h
//  SinaWeb
//
//  Created by 609972942 on 15/11/25.
//  Copyright (c) 2015年 . All rights reserved.
//

#ifndef SinaWeb_Single_h
#define SinaWeb_Single_h

//说明只需在需要写成单例的类中导入该文件，写入single_interface(class) 和 single_implementation(class) 注class为你当前类名

// .h
#define single_interface(class)  + (class *)shared##class;

// .m     \ 代表下一行也属于宏    ## 是分隔符
#define single_implementation(class) \
static class *_instance; \
\
+ (class *)shared##class \
{ \
if (_instance == nil) { \
_instance = [[self alloc] init]; \
} \
return _instance; \
} \
\
+ (id)allocWithZone:(NSZone *)zone \
{ \
static dispatch_once_t onceToken; \
dispatch_once(&onceToken, ^{ \
_instance = [super allocWithZone:zone]; \
}); \
return _instance; \
}

#endif
