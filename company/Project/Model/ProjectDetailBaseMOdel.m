//
//  ProjectDetailBaseMOdel.m
//  company
//
//  Created by Eugene on 16/6/17.
//  Copyright © 2016年 Eugene. All rights reserved.
//

#import "ProjectDetailBaseMOdel.h"

@implementation ProjectDetailBaseMOdel


+ (NSDictionary *)objectClassInArray{
    return @{@"extr" : [DetailExtr class]};
}
@end
@implementation DetailProject

+ (NSDictionary *)objectClassInArray{
    return @{@"roadshows" : [DetailRoadshows class], @"teams" : [DetailTeams class], @"projectimageses" : [DetailProjectimageses class]};
}

+(NSDictionary *)mj_replacedKeyFromPropertyName
{
   return  @{
      @"desc" : @"description"
      };
}
@end


@implementation DetailFinancestatus

@end


@implementation DetailRoadshows

@end


@implementation DetailRoadshowplan

@end


@implementation DetailTeams

@end


@implementation DetailProjectimageses

@end


@implementation DetailExtr

@end


