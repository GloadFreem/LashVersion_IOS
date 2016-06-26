//
//  InvestOrganizationBaseModel.m
//  company
//
//  Created by Eugene on 16/6/14.
//  Copyright © 2016年 Eugene. All rights reserved.
//

#import "InvestOrganizationBaseModel.h"

@implementation InvestOrganizationBaseModel


+ (NSDictionary *)objectClassInArray{
    return @{@"investors" : [OrganizationInvestors class], @"founddations" : [OrganizationFounddations class]};
}
@end
@implementation OrganizationInvestors

@end


@implementation OrganizationUser

+ (NSDictionary *)objectClassInArray{
    return @{@"authentics" : [OrganizationAuthentics class]};
}

@end


@implementation OrganizationAuthentics

@end


@implementation OrganizationCity

@end


@implementation OrganizationProvince

@end


@implementation OrganizationFounddations

@end


