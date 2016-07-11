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


@synthesize content = _content;

-(void)setContent:(NSString *)content
{
    _content = content;
}

-(NSString*)content
{
    CGFloat contentW = SCREENWIDTH - 50*WIDTHCONFIG;
    CGFloat height = [_content commonStringHeighforLabelWidth:contentW withFontSize:14];
    
    if (height > 51) {
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
