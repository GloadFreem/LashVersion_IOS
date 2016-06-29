//
//  MineLogoProjectBaseModel.m
//  company
//
//  Created by Eugene on 16/6/29.
//  Copyright © 2016年 Eugene. All rights reserved.
//

#import "MineLogoProjectBaseModel.h"

@implementation MineLogoProjectBaseModel

+(NSDictionary*)mj_replacedKeyFromPropertyName
{
    return @{
             @"desc" : @"description"
             };
}

+ (NSDictionary *)objectClassInArray{
    return @{@"roadshows" : [LogoRoadshows class]};
}


@end
@implementation LogoFinancestatus

@end


@implementation LogoRoadshows

@end


@implementation LogoRoadshowplan

@end




