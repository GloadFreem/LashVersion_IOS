//
//  ActionIntroduce.m
//  company
//
//  Created by LiLe on 16/8/24.
//  Copyright © 2016年 Eugene. All rights reserved.
//

#import "ActionIntroduce.h"

@implementation ActionIntroduce

+ (instancetype)ActionIntroducesWithDic:(NSDictionary *)dic
{
    return [[self alloc] initWithDic:dic];
}

- (instancetype)initWithDic:(NSDictionary *)dic
{
    if (self = [super init]) {
        [self setValuesForKeysWithDictionary:dic];
    }
    return self;
}
@end
