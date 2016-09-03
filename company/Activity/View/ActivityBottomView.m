//
//  ActivityBottomView.m
//  company
//
//  Created by LiLe on 16/8/22.
//  Copyright © 2016年 Eugene. All rights reserved.
//

#import "ActivityBottomView.h"
#import "UIButton+UIButtonImageWithLable.h"

@interface ActivityBottomView ()
{
    UIButton *agreeBtn;
}
@end

@implementation ActivityBottomView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        
        UIView *topLineView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREENWIDTH, 1)];
        topLineView.backgroundColor = [UIColor lightGrayColor];
        [self addSubview:topLineView];
        
        CGFloat w = self.width;
        CGFloat h = self.height;
        //报名按钮
        UIButton *commentBtn = [UIButton setImageWithName:@"iconfont_pinglun" withTitle:@"评论" forState:UIControlStateNormal];
        commentBtn.frame = CGRectMake(0, topLineView.height, w*0.3-1, h);
        commentBtn.titleLabel.font = [UIFont systemFontOfSize:14];
        commentBtn.titleLabel.textColor = RGBCOLOR(116, 116, 116);
        [commentBtn addTarget:self action:@selector(commentBtnClick) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:commentBtn];
        
        UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(commentBtn.frame), commentBtn.y+13, 1, h-26)];
        [self addSubview:lineView];
        lineView.backgroundColor = [UIColor lightGrayColor];
        
        agreeBtn =  [UIButton setImageWithName:@"icon_dianzan" withTitle:@"点赞" forState:UIControlStateNormal];
        [agreeBtn setImage:[UIImage imageNamed:@"iconfont_dianzan"] forState:UIControlStateSelected];
        agreeBtn.frame = CGRectMake(CGRectGetMaxX(lineView.frame), commentBtn.y, w*0.3, h);
        agreeBtn.titleLabel.font = commentBtn.titleLabel.font;
        agreeBtn.titleLabel.textColor = commentBtn.titleLabel.textColor;
        [agreeBtn addTarget:self action:@selector(agreeBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:agreeBtn];
        
        //按钮
        _signUpBtn = [[UIButton alloc] initWithFrame:CGRectMake(CGRectGetMaxX(agreeBtn.frame), commentBtn.y, 0.4*w, h)];
        _signUpBtn.backgroundColor = color(252, 99, 6, 1);
        [_signUpBtn setTitle:@"我要报名" forState:UIControlStateNormal];
        [_signUpBtn addTarget:self action:@selector(attendActivity) forControlEvents:UIControlEventTouchUpInside];
        [_signUpBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_signUpBtn.titleLabel setFont:BGFont(19)];
        [self addSubview:_signUpBtn];
    }
    return self;
}

-(void)setAttend:(BOOL)attend
{
    _attend = attend;
    if (_attend) {
        [_signUpBtn setTitle:@"已报名" forState:UIControlStateNormal];
        [_signUpBtn setBackgroundColor:btnCray];
        [_signUpBtn setEnabled:NO];
    }else{
        _signUpBtn.backgroundColor = color(252, 99, 6, 1);
        [_signUpBtn setTitle:@"我要报名" forState:UIControlStateNormal];
        [_signUpBtn setEnabled:YES];
    }
}

-(void)setIsExpired:(BOOL)isExpired
{
    _isExpired = isExpired;
    if (_isExpired) {
        [_signUpBtn setTitle:@"已结束" forState:UIControlStateNormal];
        [_signUpBtn setBackgroundColor:btnCray];
        [_signUpBtn setEnabled:NO];
    }
}

- (void)setFlag:(BOOL)flag
{
    _flag = flag;
    if (_flag) {
        agreeBtn.selected = YES;
    } else {
        agreeBtn.selected = NO;
    }
}

/**
 *  点赞
 */
-(void)agreeBtnClick:(UIButton *)btn
{
    if([_delegate respondsToSelector:@selector(didClickLikeButton:)])
    {
        [_delegate didClickLikeButton:btn];
    }
}

/**
 *  评论
 */
-(void)commentBtnClick
{
    if([_delegate respondsToSelector:@selector(didClickCommentButton)])
    {
        [_delegate didClickCommentButton];
    }
}

- (void)attendActivity{
    if([_delegate respondsToSelector:@selector(attendAction)])
    {
        [_delegate attendAction];
    }
    
}

@end
