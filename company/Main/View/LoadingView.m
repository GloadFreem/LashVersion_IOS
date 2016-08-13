//
//  LoadingView.m
//  company
//
//  Created by Eugene on 16/8/11.
//  Copyright © 2016年 Eugene. All rights reserved.
//

#import "LoadingView.h"

@implementation LoadingView


-(id)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        _imageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 150*WIDTHCONFIG, 150*WIDTHCONFIG)];
        ;
        _imageView.centerX = self.centerX;
        _imageView.centerY = self.centerY - 100;
        
        UIImage *image = [UIImage sd_animatedGIFNamed:@"loadingView"];
        _imageView.image = image;
        [self addSubview:_imageView];
    }
    return self;
}
#pragma mark----设置背景是否透明
-(void)setIsTransparent:(BOOL)isTransparent
{
    self->_isTransparent = isTransparent;
    if (self.isTransparent) {
        self.backgroundColor = ClearColor;
    }else{
        self.backgroundColor = [UIColor whiteColor];
    }
}
#pragma mark----是否请求报错
-(void)setIsError:(BOOL)isError
{
    self->_isError = isError;
    if (self.isError) {
        [_imageView removeFromSuperview];
        
        _imageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 126*WIDTHCONFIG, 96*WIDTHCONFIG)];
        _imageView.centerX = self.centerX;
        _imageView.centerY = self.centerY - 100;
        UIImage *image = [UIImage imageNamed:@"error"];
        _imageView.image = image;
        [self addSubview:_imageView];
        
        if (!_labelMessage) {
            _labelMessage = [[UILabel alloc]initWithFrame:CGRectMake(30, POS_Y(_imageView) + 20, WIDTH(self)-60, 20)];
            _labelMessage.font = BGFont(16);
            _labelMessage.textAlignment = NSTextAlignmentCenter;
            
            _refreshBtn = [[UIButton alloc]initWithFrame:CGRectMake(WIDTH(self)/2-60, POS_Y(_labelMessage), 120, 40)];
            _refreshBtn.layer.borderWidth = 1;
            _refreshBtn.layer.cornerRadius = 5;
            _refreshBtn.layer.borderColor = color(91, 115, 150, 1).CGColor;
            [_refreshBtn setTitle:@"再试一试" forState:UIControlStateNormal];
            [_refreshBtn setTitleColor:color(91, 115, 150, 1) forState:UIControlStateNormal];
            [_refreshBtn setTitleColor:color(91, 115, 150, 1) forState:UIControlStateHighlighted];
            [_refreshBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
            [_refreshBtn addTarget:self action:@selector(refresh) forControlEvents:UIControlEventTouchUpInside];
        }
        [self addSubview:_labelMessage];
        [self addSubview:_refreshBtn];
    }else{
        [_imageView removeFromSuperview];
        [_labelMessage removeFromSuperview];
        [_refreshBtn removeFromSuperview];
        
        _imageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 150*WIDTHCONFIG, 150*WIDTHCONFIG)];
        ;
        _imageView.centerX = self.centerX;
        _imageView.centerY = self.centerY - 100;
        
        UIImage *image = [UIImage sd_animatedGIFNamed:@"loadingView"];
        _imageView.image = image;
        [self addSubview:_imageView];
    }
}

-(void)refresh
{
    if ([self.delegate respondsToSelector:@selector(refresh)]) {
        [self.delegate refresh];
    }
}

-(void)setContent:(NSString *)content
{
    self->_content = content;
    if (self.content) {
        [TDUtil setLabelMutableText:_labelMessage content:content lineSpacing:3 headIndent:0];
        //重新设置按钮位置
        [_refreshBtn setFrame:CGRectMake(WIDTH(self)/2-50, POS_Y(_labelMessage), 100, 40)];
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
