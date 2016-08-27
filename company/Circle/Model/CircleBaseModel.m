//
//  CircleBaseModel.m
//  company
//
//  Created by Eugene on 16/6/10.
//  Copyright © 2016年 Eugene. All rights reserved.
//

#import "CircleBaseModel.h"

@implementation CircleContentprisesUsersModel


@end

@implementation CircleContentprisesContentModel



@end


@implementation CircleUsersByAtUserIdModel



@end


@implementation CircleUsersByUserIdModel



@end


@implementation CircleCommentsModel



@end


@implementation CircleContentimagesesModel



@end


@implementation CircleUsersAuthenticsCityProvinceModel



@end


@implementation CircleUsersAuthenticsCityModel



@end

@implementation CircleUsersAuthenticsIdentiytypeModel


@end

@implementation CircleUsersAuthenticsModel



@end


@implementation CircleFeeingtypeModel

@end

@implementation CircleContenttypeModel


@end

@implementation CircleContentshareModel

@end

@implementation CircleUsersModel

+ (NSDictionary *)objectClassInArray{
    return @{
             @"authentics" : @"CircleUsersAuthenticsModel"
             };
}
@end


@implementation CircleBaseModel


+ (NSDictionary *)objectClassInArray{
    return @{
             @"comments" : @"CircleCommentsModel",
             @"contentimageses" : @"CircleContentimagesesModel",
             @"contentprises" : @"CircleContentprisesContentModel"
             };
}


@end


