//
//  CircleContentView.m
//  company
//
//  Created by Eugene on 16/8/24.
//  Copyright © 2016年 Eugene. All rights reserved.
//

#import "CircleContentView.h"

@implementation CircleContentView

{
    UIView *_bottomView;
    
    UIButton *_bottomBtn;
    UIImageView *_imageView;
    UILabel *_contentLabel;
    UILabel *_titleLabel;
}


- (instancetype)initWithFrame:(CGRect)frame{
    
    self = [super initWithFrame:frame];
    if (self) {
//        self.frame = CGRectMake(0, 0, (SCREENWIDTH-16*WIDTHCONFIG), 81);
//        self.backgroundColor = [UIColor clearColor];
        [self createUI];
    }
    return self;
}

-(void)createUI
{
    
    _bottomView = [UIView new];
    _bottomView.backgroundColor = [TDUtil colorWithHexString:@"ececf0"];
//    _bottomView.backgroundColor = orangeColor;
    _bottomView.layer.cornerRadius = 2;
    _bottomView.layer.masksToBounds = YES;
    [self addSubview:_bottomView];
    _bottomView.sd_layout
    .leftEqualToView(self)
    .topEqualToView(self)
    .rightEqualToView(self)
    .heightIs(65);
    
    _bottomBtn = [UIButton new];
//    _bottomBtn.backgroundColor = [TDUtil colorWithHexString:@"ececf0"];
    _bottomBtn.backgroundColor = [UIColor clearColor];
    [_bottomBtn addTarget:self action:@selector(btnClick) forControlEvents:UIControlEventTouchUpInside];
    _bottomBtn.layer.cornerRadius = 2;
    _bottomBtn.layer.masksToBounds = YES;
    [_bottomView addSubview:_bottomBtn];
    
    
    
    _bottomBtn.sd_layout
    .leftEqualToView(_bottomView)
    .topEqualToView(_bottomView)
    .rightEqualToView(_bottomView)
    .bottomEqualToView(_bottomView);
    
    
    _imageView = [UIImageView new];
    _imageView.layer.cornerRadius = 1;
    _imageView.layer.masksToBounds = YES;
    _imageView.userInteractionEnabled = NO;
//    _imageView.backgroundColor = orangeColor;
    [_bottomView addSubview:_imageView];
    
    _imageView.sd_layout
    .leftSpaceToView(_bottomView,5)
    .topSpaceToView(_bottomView,5)
    .bottomSpaceToView(_bottomView,5)
    .widthIs(55);
    
    _contentLabel = [UILabel new];
    _contentLabel.font = BGFont(14);
    _contentLabel.textColor = color47;
    _contentLabel.numberOfLines = 2;
    _contentLabel.userInteractionEnabled = NO;
    _contentLabel.textAlignment = NSTextAlignmentLeft;
//    _contentLabel.backgroundColor = colorBlue;
    [_bottomView addSubview:_contentLabel];
    _contentLabel.sd_layout
    .leftSpaceToView(_imageView,10)
    .rightSpaceToView(_bottomView,20)
    .topSpaceToView(_bottomView, 10)
//    .centerYEqualToView(_bottomView)
    .bottomSpaceToView(_bottomView,10);
    
    _titleLabel = [UILabel new];
    _titleLabel.font = BGFont(11);
    _titleLabel.textAlignment = NSTextAlignmentLeft;
    _titleLabel.textColor = [TDUtil colorWithHexString:@"556e88"];
    [self addSubview:_titleLabel];
    
    _titleLabel.sd_layout
    .leftSpaceToView(self,14)
    .heightIs(11)
    .topSpaceToView(_bottomBtn,4);
    [_titleLabel setSingleLineAutoResizeWithMaxWidth:150];
}

-(void)setIsHidden:(BOOL)isHidden
{
    self->_isHidden = isHidden;
    if (_isHidden) {
        _bottomView.hidden = YES;
        _bottomBtn.hidden = YES;
        _contentLabel.hidden = YES;
        _titleLabel.hidden = YES;
    }else{
        _bottomView.hidden = NO;
        _bottomBtn.hidden = NO;
        _contentLabel.hidden = NO;
        _titleLabel.hidden = NO;
    }
}
-(void)setImageName:(NSString *)imageName
{
    if (imageName) {
        [_imageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",imageName]] placeholderImage:[UIImage imageNamed:@"placeholderImage"]];
    }
}

-(void)setTitleLabelText:(NSString *)titleLabelText
{
    if (titleLabelText) {
        _titleLabel.text = titleLabelText;
        [_titleLabel sizeToFit];
    }
}

-(void)setContentLabelText:(NSString *)contentLabelText
{
    if (contentLabelText) {
//        _contentLabel.text = contentLabelText;
        [TDUtil setLabelMutableText:_contentLabel content:contentLabelText lineSpacing:5 headIndent:0];
    }
}

-(void)btnClick
{
    if ([self.delegate respondsToSelector:@selector(didClickContentView)]) {
        [self.delegate didClickContentView];
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
