//
//  HeaderView.m
//  company
//
//  Created by LiLe on 16/8/23.
//  Copyright © 2016年 Eugene. All rights reserved.
//

#import "HeaderView.h"

@implementation HeaderView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = color(239, 239, 244, 1);
        
        UIView *headlineView = [[UIView alloc] initWithFrame:CGRectMake(0, 10, SCREENWIDTH, 50)];
        headlineView.backgroundColor = [UIColor whiteColor];
        [self addSubview:headlineView];
        
        UIImageView *imgView = [[UIImageView alloc] initWithFrame:CGRectMake(15, 15, 20, 20)];
        imgView.image = [UIImage imageNamed:@"iconfont-news"];
        [headlineView addSubview:imgView];
        
        UILabel *titleL = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(imgView.frame)+10, imgView.y, 100, 20)];
        titleL.text = @"金日投条";
        titleL.textColor = color(59, 173, 241, 1);
        [headlineView addSubview:titleL];
        
        UIImageView *arrowImage = [UIImageView new];
        arrowImage.frame = CGRectMake(SCREENWIDTH - 9 - 12, imgView.y, 9, 15);
        arrowImage.image = [UIImage imageNamed:@"iconfont_activityArrow"];
        [headlineView addSubview:arrowImage];
        
    }
    return self;
}

@end
