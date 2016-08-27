//
//  CircleShareBottomView.m
//  company
//
//  Created by Eugene on 16/6/12.
//  Copyright © 2016年 Eugene. All rights reserved.
//

#import "CircleShareBottomView.h"

@implementation CircleShareBottomView

- (instancetype)initWithFrame:(CGRect)frame{
    
    self = [super initWithFrame:frame];
    if (self) {
        self.frame = CGRectMake(0, 0, SCREENWIDTH, SCREENHEIGHT);
        self.backgroundColor = [UIColor clearColor];
    }
    return self;
}

- (void)createShareCircleViewWithTitleArray:(NSArray *)titleArr imageArray:(NSArray *)imageArr
{
    UIView *backgroundView = [[UIView alloc] initWithFrame:self.frame];
    backgroundView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    backgroundView.backgroundColor = [UIColor blackColor];
    backgroundView.alpha = 0.5;
    [self addSubview:backgroundView];
    
    UIView *shareView = [[UIView alloc] init];
    shareView.backgroundColor = UIColorFromRGB(0xf8f8f8);
    [self addSubview:shareView];
    self.shareView = shareView;
    [shareView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left);
        make.right.equalTo(self.mas_right);
        make.bottom.equalTo(self.mas_bottom);
        make.height.mas_equalTo(192*HEIGHTCONFIG);
    }];
    
    UILabel *shareLabel = [UILabel new];
    shareLabel.textAlignment = NSTextAlignmentCenter;
    shareLabel.text = @"分享到";
    shareLabel.textColor =color74;
    shareLabel.font = BGFont(19*HEIGHTCONFIG);
    [shareView addSubview:shareLabel];
    [shareLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(shareView.mas_centerX);
        make.top.mas_equalTo(shareView.mas_top).offset(20*HEIGHTCONFIG);
        make.height.mas_equalTo(19*HEIGHTCONFIG);
    }];
    
    CGFloat leftSpace = 10;
    CGFloat btnW = (SCREENWIDTH -20*WIDTHCONFIG)/5;
    CGFloat btnH = 50;
    CGFloat btnX = leftSpace;
    CGFloat btnY = 55 *HEIGHTCONFIG;
    for (NSInteger i = 0; i < imageArr.count ; i++) {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame = CGRectMake(btnX + btnW * i, btnY, btnW, btnH);
        btn.tag = i;
        //        [btn setBackgroundColor:[UIColor redColor]];
        [btn setImage:[UIImage imageNamed:imageArr[i]] forState:UIControlStateNormal];
        btn.imageView.contentMode = UIViewContentModeCenter;
        btn.layer.cornerRadius = 5;
        btn.layer.masksToBounds = YES;
        [btn addTarget:self action:@selector(shareBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [shareView addSubview:btn];
        
        UILabel *textLabel = [UILabel new];
        textLabel.text = titleArr[i];
        textLabel.textAlignment = NSTextAlignmentCenter;
        textLabel.font = BGFont(13);
        textLabel.textColor = color47;
        [shareView addSubview:textLabel];
        [textLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(btn.mas_bottom).offset(10);
            make.height.mas_equalTo(13);
            make.centerX.mas_equalTo(btn.mas_centerX);
        }];
    }
    
    UIButton *cancelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [cancelBtn setImage:[UIImage imageNamed:@"icon_share_close"] forState:UIControlStateNormal];
    //    cancelBtn.size = cancelBtn.currentBackgroundImage.size;
    cancelBtn.tag = 100;
    [cancelBtn addTarget:self action:@selector(shareBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [shareView addSubview:cancelBtn];
    [cancelBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(shareView.mas_centerX);
        make.bottom.mas_equalTo(shareView.mas_bottom).offset(-19*HEIGHTCONFIG);
        make.width.height.mas_equalTo(35);
    }];

}
- (void)createShareViewWithTitleArray:(NSArray *)titleArr imageArray:(NSArray *)imageArr
{
    UIView *backgroundView = [[UIView alloc] initWithFrame:self.frame];
    backgroundView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    backgroundView.backgroundColor = [UIColor blackColor];
    backgroundView.alpha = 0.5;
    [self addSubview:backgroundView];
    
    UIView *shareView = [[UIView alloc] init];
    shareView.backgroundColor = UIColorFromRGB(0xf8f8f8);
    [self addSubview:shareView];
    self.shareView = shareView;
    [shareView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left);
        make.right.equalTo(self.mas_right);
        make.bottom.equalTo(self.mas_bottom);
        make.height.mas_equalTo(192*HEIGHTCONFIG);
    }];
    
    UILabel *shareLabel = [UILabel new];
    shareLabel.textAlignment = NSTextAlignmentCenter;
    shareLabel.text = @"分享到";
    shareLabel.textColor =color74;
    shareLabel.font = BGFont(19*HEIGHTCONFIG);
    [shareView addSubview:shareLabel];
    [shareLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(shareView.mas_centerX);
        make.top.mas_equalTo(shareView.mas_top).offset(20*HEIGHTCONFIG);
        make.height.mas_equalTo(19*HEIGHTCONFIG);
    }];
    
    CGFloat leftSpace = 27;
    CGFloat btnW = (SCREENWIDTH -54*WIDTHCONFIG)/4;
    CGFloat btnH = 50;
    CGFloat btnX = leftSpace;
    CGFloat btnY = 55 *HEIGHTCONFIG;
    for (NSInteger i = 0; i < imageArr.count ; i++) {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame = CGRectMake(btnX + btnW * i, btnY, btnW, btnH);
        btn.tag = i;
//        [btn setBackgroundColor:[UIColor redColor]];
        [btn setImage:[UIImage imageNamed:imageArr[i]] forState:UIControlStateNormal];
        btn.imageView.contentMode = UIViewContentModeCenter;
        btn.layer.cornerRadius = 5;
        btn.layer.masksToBounds = YES;
        [btn addTarget:self action:@selector(shareBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [shareView addSubview:btn];
        
        UILabel *textLabel = [UILabel new];
        textLabel.text = titleArr[i];
        textLabel.textAlignment = NSTextAlignmentCenter;
        textLabel.font = BGFont(13);
        textLabel.textColor = color47;
        [shareView addSubview:textLabel];
        [textLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(btn.mas_bottom).offset(10);
            make.height.mas_equalTo(13);
            make.centerX.mas_equalTo(btn.mas_centerX);
        }];
    }
    
    UIButton *cancelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [cancelBtn setImage:[UIImage imageNamed:@"icon_share_close"] forState:UIControlStateNormal];
//    cancelBtn.size = cancelBtn.currentBackgroundImage.size;
    cancelBtn.tag = 100;
    [cancelBtn addTarget:self action:@selector(shareBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [shareView addSubview:cancelBtn];
    [cancelBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(shareView.mas_centerX);
        make.bottom.mas_equalTo(shareView.mas_bottom).offset(-19*HEIGHTCONFIG);
        make.width.height.mas_equalTo(35);
    }];
    
}

- (void)shareBtnClick:(UIButton *)btn{
    
    if ([self.delegate respondsToSelector:@selector(sendShareBtnWithView:index:)]) {
        
        [self.delegate sendShareBtnWithView:self index:(int)btn.tag];
    }
    
}
@end
