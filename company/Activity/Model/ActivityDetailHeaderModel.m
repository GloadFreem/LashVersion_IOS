//
//  ActivityDetailHeaderModel.m
//  JinZhiT
//
//  Created by Eugene on 16/5/20.
//  Copyright © 2016年 Eugene. All rights reserved.
//

#import "ActivityDetailHeaderModel.h"
#import "ActionIntroduce.h"
#import "ActionIntroduceFrame.h"

#import <UIKit/UIKit.h>

extern CGFloat maxContentLabelHeight;

@implementation ActivityDetailHeaderModel

@synthesize content = _content;

+ (instancetype)activityViewModelWithDic:(NSDictionary *)dic
{
    return [[self alloc] initWithDic:dic];
}

- (instancetype)initWithDic:(NSDictionary *)dic
{
    if (self = [super init]) {
        [self setValuesForKeysWithDictionary:dic];
//        NSMutableArray *tempArr = [NSMutableArray array];
//        for (NSDictionary *dic in _actionIntroduceFrames) {
//            ActionIntroduce *actionIntro = [ActionIntroduce actionIntroducesWithDic:dic];
//            [tempArr addObject:actionIntro];
//        }
//        
//        NSMutableArray *tempArr1 = [NSMutableArray array];
//        for (ActionIntroduce *actionIntro in tempArr) {
//            ActionIntroduceFrame *actionIntroF = [[ActionIntroduceFrame alloc] init];
//            actionIntroF.actionIntro = actionIntro;
//            [tempArr1 addObject:actionIntroF];
//        }
//        _actionIntroduceFrames = tempArr1;
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


-(void)setContent:(NSString *)content
{
    _content = content;
}

-(NSString*)content
{
    CGFloat contentW = SCREENWIDTH - 45*WIDTHCONFIG;
    CGFloat height = [_content commonStringHeighforLabelWidth:contentW withFontSize:14];
    if (height > maxContentLabelHeight) {
        _shouldShowMoreButton = YES;
    }
    else{
        _shouldShowMoreButton = NO;
    }
    return _content;
}

-(void)setIsOpen:(BOOL)isOpen
{
    if (!_shouldShowMoreButton) {
        _isOpen = NO;
    }
    else{
        _isOpen = isOpen;
    }
}

@end
