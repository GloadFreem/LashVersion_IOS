//
//  ThinkTankBaseModel.m
//  company
//
//  Created by Eugene on 16/6/14.
//  Copyright © 2016年 Eugene. All rights reserved.
//

#import "ThinkTankBaseModel.h"

@implementation ThinkTankBaseModel


@end

@implementation ThinkUser

+ (NSDictionary *)objectClassInArray{
    return @{@"authentics" : [ThinkAuthentics class]};
}

@end


@implementation ThinkAuthentics

@end


@implementation ThinkCity

@end


@implementation ThinkProvince

@end


