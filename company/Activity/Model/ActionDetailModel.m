//
//  ActionDetailModel.m
//  company
//
//  Created by air on 16/6/14.
//  Copyright © 2016年 Eugene. All rights reserved.
//

#import "ActionDetailModel.h"

@implementation ActionDetailModel
@synthesize description;

+ (NSDictionary *)objectClassInArray{
    return @{@"actionimages" : [Actionimages class]};
}

+(NSDictionary*)mj_replacedKeyFromPropertyName
{
    return @{@"desc":@"description"};
}
@end


@implementation Actionimages

@end



