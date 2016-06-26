//
//  ProjectDetailLeftHeaderModel.m
//  JinZhiT
//
//  Created by Eugene on 16/6/1.
//  Copyright © 2016年 Eugene. All rights reserved.
//

#import "ProjectDetailLeftHeaderModel.h"

extern CGFloat __maxContentLabelHeight;

@implementation ProjectDetailLeftHeaderModel


@synthesize contentStr = _contentStr;

-(void)setContent:(NSString *)content
{
    _contentStr = content;
}

-(NSString*)content
{
    CGFloat contentW = SCREENWIDTH - 50*WIDTHCONFIG;
    CGFloat height = [_contentStr commonStringHeighforLabelWidth:contentW withFontSize:14];
    if (height > __maxContentLabelHeight) {
        _shouldShowMoreButton = YES;
    }
    else{
        _shouldShowMoreButton = NO;
    }
    return _contentStr;
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
