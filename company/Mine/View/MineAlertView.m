//
//  MineAlertView.m
//  company
//
//  Created by Eugene on 16/6/28.
//  Copyright © 2016年 Eugene. All rights reserved.
//

#import "MineAlertView.h"

@implementation MineAlertView

- (instancetype)initWithFrame:(CGRect)frame{
    
    self = [super initWithFrame:frame];
    if (self) {
        self.frame = CGRectMake(0, 0, SCREENWIDTH, SCREENHEIGHT);
        self.backgroundColor = [UIColor clearColor];
    }
    return self;
}

-(void)createAlertViewWithBtnTitleArray:(NSArray*)titleArray andContent:(NSString*)content
{
    UIView *backgroundView = [[UIView alloc] initWithFrame:self.frame];
    backgroundView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    backgroundView.backgroundColor = [UIColor blackColor];
    backgroundView.alpha = 0.5;
    [self addSubview:backgroundView];
    
    UIView *alertView = [UIView new];
    alertView.layer.cornerRadius = 5;
    alertView.layer.masksToBounds = YES;
    alertView.backgroundColor = UIColorFromRGB(0xf8f8f8);
    [self addSubview:alertView];
    self.alertView = alertView;
    [alertView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self);
        make.centerY.mas_equalTo(self);
        make.width.mas_equalTo(290*WIDTHCONFIG);
        make.height.mas_equalTo(170*HEIGHTCONFIG);
    }];
    
    UIImageView *image = [UIImageView new];
    image.image = [UIImage imageNamed:@"icon_warning"];
    image.size = image.image.size;
    [alertView addSubview:image];
    [image mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(alertView);
        make.top.mas_equalTo(13);
    }];
    
    _contentLabel = [UILabel new];
    _contentLabel.text = content;
    _contentLabel.textColor = color47;
    _contentLabel.font = BGFont(17);
    _contentLabel.textAlignment = NSTextAlignmentCenter;
    _contentLabel.numberOfLines = 0;
    [alertView addSubview:_contentLabel];
    [_contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(image.mas_bottom).offset(10);
        make.left.mas_equalTo(alertView.mas_left).offset(30);
        make.right.mas_equalTo(alertView.mas_right).offset(-30);
    }];
    
    UIButton *leftBtn = [UIButton new];
    leftBtn.tag = 0;
    leftBtn.backgroundColor = [UIColor whiteColor];
    [leftBtn setTitle:@"解绑" forState:UIControlStateNormal];
    [leftBtn setTitleColor:color74 forState:UIControlStateNormal];
    [leftBtn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    leftBtn.titleLabel.font = BGFont(17);
    leftBtn.layer.cornerRadius = 2;
    leftBtn.layer.masksToBounds = YES;
    leftBtn.layer.borderColor = color47.CGColor;
    leftBtn.layer.borderWidth = 0.5;
    [alertView addSubview:leftBtn];
    [leftBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(_contentLabel.mas_left);
        make.width.mas_equalTo(95*WIDTHCONFIG);
        make.height.mas_equalTo(30);
        make.top.mas_equalTo(_contentLabel.mas_bottom).offset(15);
    }];
    
    UIButton *rightBtn = [UIButton new];
    [rightBtn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    rightBtn.tag = 1;
    rightBtn.backgroundColor = orangeColor;
    [rightBtn setTitle:@"返回" forState:UIControlStateNormal];
    [rightBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    rightBtn.titleLabel.font= BGFont(17);
    rightBtn.layer.cornerRadius = 2;
    rightBtn.layer.masksToBounds = YES;
    
    [alertView addSubview:rightBtn];
    [rightBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(_contentLabel.mas_right);
        make.width.mas_equalTo(95*WIDTHCONFIG);
        make.height.mas_equalTo(30);
        make.top.mas_equalTo(_contentLabel.mas_bottom).offset(15);
    }];
    
}

-(void)btnClick:(UIButton*)btn
{
    if ([self.delegate respondsToSelector:@selector(didClickBtnInView:andIndex:)]) {
        [self.delegate didClickBtnInView:self andIndex:btn.tag];
    }
}
@end
