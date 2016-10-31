//
//  LoadingBlackView.m
//  company
//
//  Created by Eugene on 2016/10/28.
//  Copyright © 2016年 Eugene. All rights reserved.
//

#import "LoadingBlackView.h"

@implementation LoadingBlackView

-(instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor blackColor];
        self.alpha = 0.5;
    }
    return self;
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
