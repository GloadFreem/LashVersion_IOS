//
//  Headline.m
//  company
//
//  Created by LiLe on 16/8/24.
//  Copyright © 2016年 Eugene. All rights reserved.
//

#import "Headline.h"

@implementation Headline
- (void)setValue:(id)value forUndefinedKey:(NSString *)key
{
    if ([key isEqualToString:@"orignal"]) {
        _source = value;
    } else if ([key isEqualToString:@"createDate"]) {
        _date = value;
    } else if ([key isEqualToString:@"image"]) {
        _imgName = value;
    }
}

+ (instancetype)headlineWithDict:(NSDictionary *)dict
{
    return [[self alloc] initWithDict:dict];
}

- (instancetype)initWithDict:(NSDictionary *)dict
{
    if (self = [super init]) {
        [self setValuesForKeysWithDictionary:dict];
        NSDictionary *dic = [dict objectForKey:@"contenttype"];
        _name = [dic objectForKey:@"name"];
    }
    return self;
}
@end
