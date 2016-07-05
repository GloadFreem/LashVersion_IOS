//
//  ProjectBannerModel.m
//  JinZhiT
//
//  Created by Eugene on 16/5/8.
//  Copyright © 2016年 Eugene. All rights reserved.
//

#import "ProjectBannerModel.h"

@implementation ProjectBannerModel


@end




@implementation Extr

+ (NSDictionary *)objectClassInArray{
    return @{@"roadshows" : [BannerRoadshows class]};
}

@end


@implementation BannerFinancestatus

@end


@implementation BannerRoadshows

@end


@implementation BannerRoadshowplan

@end


@implementation Body

+(NSDictionary*)mj_replacedKeyFromPropertyName
{
    return @{@"desc" : @"description"};
}

@end


