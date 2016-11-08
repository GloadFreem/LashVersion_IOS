//
//  BaseTabBar.m
//  Company
//
//  Created by Eugene on 2016/10/8.
//  Copyright © 2016年 Eugene. All rights reserved.
//

#import "BaseTabBar.h"
#import "MineViewController.h"
#import "MyNavViewController.h"

@interface BaseTabBar ()
@property (nonatomic,strong) UIButton *publishBtn;
@end

@implementation BaseTabBar

-(instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor whiteColor];
        
        //设置tabbar文字颜色
        UITabBarItem *appearance = [UITabBarItem appearance];
        [appearance setTitleTextAttributes:@{NSForegroundColorAttributeName : orangeColor} forState:UIControlStateSelected];
        
        UIButton *mineBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [mineBtn setBackgroundImage:[UIImage imageNamed:@"tabBar_mine"] forState:UIControlStateNormal];
        [mineBtn setBackgroundImage:[UIImage imageNamed:@"tabBar_mine"] forState:UIControlStateHighlighted];
        [mineBtn addTarget:self action:@selector(pushMine) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:mineBtn];
        [mineBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_equalTo(self.centerX);
            make.size.mas_equalTo(CGSizeMake(84, 69.5));
            make.bottom.mas_equalTo(self.mas_bottom);
        }];
        
        self.publishBtn = mineBtn;
        
    }
    return self;
}

-(void)pushMine
{
    MineViewController *mine = [[MineViewController alloc]init];
    MyNavViewController *navBsae = [[MyNavViewController alloc]initWithRootViewController:mine];
    [self.window.rootViewController presentViewController:navBsae animated:YES completion:nil];
}

//重新设置按钮的位置
-(void)layoutSubviews {
    
    [super layoutSubviews];
    
    CGFloat width = self.width;
    CGFloat height = self.height;
    NSInteger index = 0;
    CGFloat btnW = width / 5;
    CGFloat btnH = height;
    CGFloat btnY = 0;

    //遍历取出按钮
    for (UIControl *control in self.subviews) {
        if (![control isKindOfClass:[UIControl class]] || [control isKindOfClass:[UIButton class]]) continue; {
            CGFloat btnX = (index > 1 ? (index +1) : index) *btnW;
            control.frame = CGRectMake(btnX, btnY, btnW, btnH);
            index++;
        }
    }
    
    
}
@end
