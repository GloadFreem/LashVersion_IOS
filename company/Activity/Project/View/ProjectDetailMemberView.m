//
//  ProjectDetailMemberView.m
//  JinZhiT
//
//  Created by Eugene on 16/5/13.
//  Copyright © 2016年 Eugene. All rights reserved.
//

#import "ProjectDetailMemberView.h"

@implementation ProjectDetailMemberView

-(instancetype)initWithFrame:(CGRect)frame
{
    if ([super initWithFrame:frame]) {
        
    }
    return self;
}


#pragma mark- 实例化视图
+(ProjectDetailMemberView*)instancetationProjectDetailMemberView
{
    ProjectDetailMemberView *view =[[[NSBundle mainBundle] loadNibNamed:@"ProjectDetailMemberView" owner:nil options:nil] lastObject];
   
    return view;
}

-(id)initWithCoder:(NSCoder *)aDecoder
{
    if ([super initWithCoder:aDecoder]) {
        
        //加载数据
        //    [view refreshData];
        //计算View的高度
        
        self.viewHeight = 300;
//        [self setupAutoHeightWithBottomView:_emailLabel bottomMargin:30];
        NSLog(@"实例化成员界面");
    }
    return self;
}

#pragma mark -加载数据
-(void)refreshData
{
    
}

@end
