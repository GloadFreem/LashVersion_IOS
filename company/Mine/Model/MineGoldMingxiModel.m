//
//  MineGoldMingxiModel.m
//  JinZhiT
//
//  Created by Eugene on 16/5/24.
//  Copyright © 2016年 Eugene. All rights reserved.
//

#import "MineGoldMingxiModel.h"

@implementation MineGoldMingxiModel

@synthesize yearStr = _yearStr;

-(void)setYearStr:(NSString *)yearStr
{
    _yearStr = yearStr;
}

-(NSString*)yearStr
{
    if ([_yearStr isEqualToString:@""]) {
        _isShow = NO;
    }else{
        _isShow = YES;
    }
    return _yearStr;
}

@end
