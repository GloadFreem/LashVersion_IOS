//
//  ActivityViewModel.m
//  company
//
//  Created by air on 16/06/14
//  Copyright (c) Eugene. All rights reserved.
//

#import "ActivityViewModel.h"
#import "ActionIntroduce.h"

@implementation ActivityViewModel

+ (instancetype)activityViewModelWithDic:(NSDictionary *)dic
{
    return [[self alloc] initWithDic:dic];
}

- (instancetype)initWithDic:(NSDictionary *)dic
{
    if (self = [super init]) {
        [self setValuesForKeysWithDictionary:dic];
        NSMutableArray *tempArr = [NSMutableArray array];
        for (NSDictionary *dic in _actionintroduces) {
            ActionIntroduce *actionIntro = [ActionIntroduce ActionIntroducesWithDic:dic];
            [tempArr addObject:actionIntro];
        }
        _actionintroduces = tempArr;
    }
    return self;
}

- (void)setValue:(id)value forUndefinedKey:(NSString *)key
{

}

+(NSDictionary*)mj_replacedKeyFromPropertyName
{
    return @{@"desc":@"description", @"imgUrl":@"startPageImage"};
}
@end
