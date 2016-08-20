//
//  noNetView.m
//  company
//
//  Created by Eugene on 16/8/19.
//  Copyright © 2016年 Eugene. All rights reserved.
//

#import "noNetView.h"

@implementation noNetView


-(instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = color(76, 82, 100, 1);
        [self createUI];
    }
    return self;
}

-(void)createUI
{
    _containerView = [UIView new];
    
    [self addSubview:_containerView];
    
    _imageView = [UIImageView new];
    _imageView.image = [UIImage imageNamed:@"icon_noNet"];
    [_containerView addSubview:_imageView];
    
    _imageView.sd_layout
    .leftEqualToView(_containerView)
    .centerYEqualToView(_containerView)
    .widthIs(21)
    .heightIs(21);
    
    _titleLabel = [UILabel new];
    _titleLabel.text = @"当前网络不可用，请检查网络设置";
    _titleLabel.textColor = [UIColor whiteColor];
    _titleLabel.font = BGFont(14);
    _titleLabel.textAlignment = NSTextAlignmentRight;
    [_containerView addSubview:_titleLabel];
    _titleLabel.sd_layout
    .leftSpaceToView(_imageView,5)
//    .rightSpaceToView(_containerView,5)
    .centerYEqualToView(_containerView)
    .heightIs(15);
    [_titleLabel setSingleLineAutoResizeWithMaxWidth:300];
    
    _containerView.sd_layout
    .topEqualToView(self)
    .bottomEqualToView(self)
    .centerXEqualToView(self)
    .widthIs(240);
    
    _btn = [UIButton new];
    _btn.backgroundColor = [UIColor clearColor];
    [_btn addTarget:self action:@selector(btnClick) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_btn];
    _btn.sd_layout
    .leftEqualToView(self)
    .rightEqualToView(self)
    .topEqualToView(self)
    .bottomEqualToView(self);
}

-(void)btnClick
{
    if ([self.delegate respondsToSelector:@selector(didClickBtnInView)]) {
        [self.delegate didClickBtnInView];
    }
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
