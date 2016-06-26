//
//  ProjectListProBaseModel.m
//  company
//
//  Created by Eugene on 16/6/15.
//  Copyright © 2016年 Eugene. All rights reserved.
//

#import "ProjectListProBaseModel.h"

@implementation ProjectListProBaseModel

@end
@implementation Project

+ (NSDictionary *)objectClassInArray{
    return @{@"roadshows" : [Roadshows class]};
}

+ (NSDictionary *)mj_replacedKeyFromPropertyName
{
    return @{
             @"desc" : @"description"
             };
}
@end


@implementation Financestatus

@end


@implementation Roadshows

@end


@implementation Roadshowplan

@end


