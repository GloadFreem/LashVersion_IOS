//
//  ActivityDetailFooterView.m
//  JinZhiT
//
//  Created by Eugene on 16/6/3.
//  Copyright © 2016年 Eugene. All rights reserved.
//

#import "ActivityCommentListFooterView.h"

@interface ActivityCommentListFooterView()
@property (nonatomic, strong) UIButton *praiseBtn;
@property (nonatomic, strong) UIButton *commentBtn;

@end
@implementation ActivityCommentListFooterView

-(instancetype)initWithFrame:(CGRect)frame
{
    if ( self = [super initWithFrame:frame]) {
        [self setupViews];
    }
    return self;
}

-(void)setupViews
{
    
    _praiseBtn = [UIButton new];
    [_praiseBtn setBackgroundImage:[UIImage imageNamed:@"iconfont-zan"] forState:UIControlStateNormal];
    [_praiseBtn addTarget:self action:@selector(praiseBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    _praiseBtn.size = _praiseBtn.currentBackgroundImage.size;
    [self addSubview:_praiseBtn];
    _praiseBtn.sd_layout
    .topSpaceToView(self, 30)
    .rightSpaceToView(self, 24 + SCREENWIDTH/2)
    .widthIs(42)
    .heightIs(42);
    
    _commentBtn =[UIButton new];
    [_commentBtn setBackgroundImage:[UIImage imageNamed:@"icon_comment"] forState:UIControlStateNormal];
    [_commentBtn addTarget:self action:@selector(commentBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    _commentBtn.size = _commentBtn.currentBackgroundImage.size;
    [self addSubview:_commentBtn];
    _commentBtn.sd_layout
    .topEqualToView(_praiseBtn)
    .leftSpaceToView(_praiseBtn, 48)
    .widthIs(42)
    .heightIs(42);
    
//    self.sd_layout
//    .heightIs(100);
    
    [self setupAutoHeightWithBottomView:_commentBtn bottomMargin:50];
}
/**
 *  点赞
 *
 *  @param btn button
 */
-(void)praiseBtnClick:(UIButton*)btn
{
    if([_delegate respondsToSelector:@selector(didClickLikeButton)])
    {
        [_delegate didClickLikeButton];
    }

}

/**
 *  评论
 *
 *  @param btn button
 */
-(void)commentBtnClick:(UIButton*)btn
{
    if([_delegate respondsToSelector:@selector(didClickCommentButton)])
    {
        [_delegate didClickCommentButton];
    }
}

@end
