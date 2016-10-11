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
{
    UIImageView *imageV;
}
- (void)setActionIntro:(ActionIntroduce *)actionIntro
{
    _actionIntro = actionIntro;
    
    if (_actionIntro.type == 1) {
        imageV = [UIImageView new];
        [imageV sd_setImageWithURL:[NSURL URLWithString:_actionIntro.content] placeholderImage:[UIImage imageNamed:@"placeholderImage"]];
        [imageV setContentMode:UIViewContentModeScaleAspectFill];
//        [imageV sd_setImageWithURL:[NSURL URLWithString:_actionIntro.content] placeholderImage:[UIImage imageNamed:@"placeholderImage"] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
//            CGFloat width = imageV.image.size.width;
//            NSLog(@"打印宽度---%f",width);
//            CGFloat height = imageV.image.size.height;
//            //        NSLog(@"打印高度---%f",height);
//            CGFloat scale = (SCREENWIDTH - 20)/width;
//            CGFloat imageHeight  = scale * height;
//            _cellHeight = imageHeight + 20;
//        }];
        CGFloat width = imageV.image.size.width;
//        NSLog(@"打印宽度---%f",width);
        CGFloat height = imageV.image.size.height;
//        NSLog(@"打印高度---%f",height);
        CGFloat scale = (SCREENWIDTH - 20)/width;
        CGFloat imageHeight  = scale * height;
        _cellHeight = imageHeight + 20;
//        _cellHeight = 180;
//        NSLog(@"dayin 高度---%f",imageHeight);
//        CGSize imageSize = [TDUtil getImageSizeWithURL:_actionIntro.content];
//        NSLog(@"第二种方法打印宽度---%lf，高度---%f",imageSize.width,imageSize.height);
//        NSLog(@"打印宽度---%lf",imageSize.width);
//        NSLog(@"打印高度---%f",_cellHeight);
//        return;
    }else{
    
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
//    _cellHeight = CGRectGetMaxY(_contextLF);
        _cellHeight = size.height;
//        NSLog(@"打印高度---%f",_cellHeight);
    }
}
@end
