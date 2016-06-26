//
//  CircleListModel.m
//  JinZhiT
//
//  Created by Eugene on 16/5/26.
//  Copyright © 2016年 Eugene. All rights reserved.
//

#import "CircleListModel.h"
#import <UIKit/UIKit.h>

extern const CGFloat _contentLabelFontSize;
extern CGFloat _maxContentLabelHeight;

@implementation CircleListModel

{
    CGFloat _lastContentWidth;
}

@synthesize msgContent = _msgContent;

-(void)setMsgContent:(NSString *)msgContent
{
    _msgContent = msgContent;
}

-(NSString*)msgContent
{
    CGFloat contentW = SCREENWIDTH -14;
    if (contentW != _lastContentWidth) {
        _lastContentWidth = contentW;
        
        CGFloat height = [_msgContent commonStringHeighforLabelWidth:contentW withFontSize:_contentLabelFontSize];
        if (height > _maxContentLabelHeight) {
            _shouldShowMoreBtn = YES;
        }else{
            _shouldShowMoreBtn = NO;
        }
    }
    return _msgContent;
}

-(void)setIsOpening:(BOOL)isOpening
{
    if (!_shouldShowMoreBtn) {
        _isOpening = NO;
    }else{
        _isOpening = isOpening;
    }
}
@end
