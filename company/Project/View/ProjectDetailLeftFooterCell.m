//
//  ProjectDetailLeftFooterCell.m
//  JinZhiT
//
//  Created by Eugene on 16/6/1.
//  Copyright © 2016年 Eugene. All rights reserved.
//

#import "ProjectDetailLeftFooterCell.h"

@implementation ProjectDetailLeftFooterCell

{
    UIScrollView *_scrollView;
    UIView *_bottomView;
}

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
                [self setup];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        
    }
    return self;
}


-(void)setup
{
    _scrollView = [UIScrollView new];
    _scrollView.delegate = self;
    _scrollView.backgroundColor  = [UIColor magentaColor];
    
    _scrollView.sd_layout
    .leftEqualToView(self.contentView)
    .rightEqualToView(self.contentView)
    .topSpaceToView(self.contentView,0)
    .heightIs(120);
    
    
    
    _bottomView = [UIView new];
    _bottomView.backgroundColor = colorGray;
    _bottomView.sd_layout
    .leftEqualToView(self.contentView)
    .bottomEqualToView(self.contentView)
    .rightEqualToView(self.contentView)
    .heightIs(10);
    
    NSArray *views = @[_scrollView, _bottomView];
    
    [self.contentView sd_addSubviews:views];
    
    [self setupAutoHeightWithBottomView:_bottomView bottomMargin:0];
    
    //测试
    //    [self setModelArray:NULL];
    
}



-(void)setModelArray:(NSArray *)modelArray
{
    CGFloat leftSpace = 22.5 * WIDTHCONFIG;
    CGFloat width = 50 * WIDTHCONFIG;
    CGFloat space = (SCREENWIDTH - 45 * WIDTHCONFIG  - width * modelArray.count) /(modelArray.count - 1);
    NSInteger i = 0;
    for (; i < modelArray.count; i++) {
        DetailExtr *model = modelArray[i];
        UIButton *btn = [UIButton new];
        btn.backgroundColor = [UIColor greenColor];
        btn.layer.cornerRadius = 25;
        btn.layer.masksToBounds = YES;
        
        btn.frame = CGRectMake(leftSpace + (width + space) * i, 15, width, width);
        [_scrollView addSubview:btn];
        
//        [btn setBackgroundImage:IMAGENAMED(@"Avatar-sample-165") forState:UIControlStateNormal];
        [btn sd_setBackgroundImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",model.icon]] forState:UIControlStateNormal];
        
        UILabel *label = [UILabel new];
        label.textAlignment = NSTextAlignmentCenter;
        label.backgroundColor = orangeColor;
        
        label.textColor = [UIColor blackColor];
        label.font = BGFont(12);
        label.numberOfLines = 2;
        [_scrollView addSubview:label];
        
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(btn);
            make.top.mas_equalTo(btn.mas_bottom).offset(5);
            make.height.mas_equalTo(28);
            make.width.mas_equalTo(26);
        }];
        
        NSLog(@"打印footercell的文字---%@",model.content);
        NSString *pre = [model.content substringToIndex:2];
        NSString *last = [model.content substringFromIndex:2];
        label.text = [NSString stringWithFormat:@"%@\n%@",pre,last];
        
    }
    
    
}

@end
