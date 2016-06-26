//
//  MineCollectionProjectModel.m
//  company
//
//  Created by Eugene on 16/6/26.
//  Copyright © 2016年 Eugene. All rights reserved.
//

#import "MineCollectionProjectModel.h"

@implementation MineCollectionProjectModel


+(NSDictionary*)mj_replacedKeyFromPropertyName
{
    return @{
             @"desc" : @"description"
             };
}

+ (NSDictionary *)objectClassInArray{
    return @{@"roadshows" : [MineRoadshows class]};
}
@end


@implementation MineFinancestatus

@end


@implementation MineRoadshows

@end


@implementation MineRoadshowplan

@end








