//
//  MineGoldBtn.m
//  company
//
//  Created by Eugene on 16/8/15.
//  Copyright © 2016年 Eugene. All rights reserved.
//

#import "MineGoldBtn.h"

@implementation MineGoldBtn


-(void)layoutSubviews
{
    [super layoutSubviews];
    CGFloat midX = self.frame.size.width / 2;
    CGFloat midY = self.frame.size.height/ 2 ;
    self.titleLabel.center = CGPointMake(midX, midY + 30);
    self.imageView.center = CGPointMake(midX, midY - 10);
    
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
