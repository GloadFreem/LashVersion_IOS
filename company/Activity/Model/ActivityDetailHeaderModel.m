//
//  ActivityDetailHeaderModel.m
//  JinZhiT
//
//  Created by Eugene on 16/5/20.
//  Copyright © 2016年 Eugene. All rights reserved.
//

#import "ActivityDetailHeaderModel.h"

#import <UIKit/UIKit.h>

extern CGFloat maxContentLabelHeight;

@implementation ActivityDetailHeaderModel

@synthesize content = _content;

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
