//
//  ActionIntroduceFrame.m
//  company
//
//  Created by LiLe on 16/8/25.
//  Copyright © 2016年 Eugene. All rights reserved.
//

#import "ActionIntroduceFrame.h"
#import "ActionIntroduce.h"

const CGFloat intro_marginLeft = 10;
const CGFloat margingTop = 0;

@implementation ActionIntroduceFrame
- (void)setActionIntro:(ActionIntroduce *)actionIntro
{
    _actionIntro = actionIntro;
    
    if (_actionIntro.type == 1) {
        _cellHeight = 180;
        return;
    }
    
//    CGSize size = [_actionIntro.content sizeWithFont:[UIFont systemFontOfSize:14] constrainedToSize:CGSizeMake(SCREENWIDTH-marginLeft*2, MAXFLOAT) lineBreakMode:NSLineBreakByWordWrapping];
    
    NSMutableDictionary *attrs = [NSMutableDictionary dictionary];
    attrs[NSFontAttributeName] = [UIFont systemFontOfSize:13];
    
//    CGSize size =  [_actionIntro.content boundingRectWithSize:CGSizeMake(SCREENWIDTH-intro_marginLeft*2, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:attrs context:nil].size;
//    _contextLF = CGRectMake(intro_marginLeft, margingTop, size.width, size.height);
    
    
    NSMutableParagraphStyle *paraStyle = [[NSMutableParagraphStyle alloc] init];
    paraStyle.lineBreakMode = NSLineBreakByCharWrapping;
    paraStyle.alignment = NSTextAlignmentLeft;
    paraStyle.lineSpacing = 12;
    paraStyle.hyphenationFactor = 1.0;
    paraStyle.firstLineHeadIndent = 0.0;
    paraStyle.paragraphSpacingBefore = 0.0;
    paraStyle.headIndent = 0;
    paraStyle.tailIndent = 0;
    NSDictionary *dic = @{NSFontAttributeName:[UIFont systemFontOfSize:13], NSParagraphStyleAttributeName:paraStyle, NSKernAttributeName:@1.5f};
    
    CGSize size = [_actionIntro.content boundingRectWithSize:CGSizeMake(SCREENWIDTH-intro_marginLeft*2, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:dic context:nil].size;
      _contextLF = CGRectMake(intro_marginLeft, margingTop, SCREENWIDTH-intro_marginLeft*2, size.height);
    
    
    // cell的高度
    _cellHeight = CGRectGetMaxY(_contextLF);
}
@end
