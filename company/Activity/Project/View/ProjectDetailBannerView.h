//
//  ProjectDetailBannerView.h
//  JinZhiT
//
//  Created by Eugene on 16/5/9.
//  Copyright © 2016年 Eugene. All rights reserved.
//


//------------------------------项目详情页面上边的滚动视图-----------------------------

#import <UIKit/UIKit.h>

@class ProjectDetailBannerView;
@protocol ProjectDetailBannerViewDelegate <NSObject>

@optional
//代理方法

-(void)transportProjectDetailBannerView:(ProjectDetailBannerView*)view andTagValue:(NSInteger)tagValue;

@end
@interface ProjectDetailBannerView : UIView<UIScrollViewDelegate>


@property (nonatomic, strong) id<ProjectDetailBannerViewDelegate>delegate;
@property (nonatomic, strong) UIScrollView * scrollView;
@property (nonatomic, strong) NSTimer * timer;
//下边三个btn
@property (nonatomic, strong) UIButton * detailBtn;//详情btn
@property (nonatomic, strong) UIButton * memberBtn;//成员btn
@property (nonatomic, strong) UIButton * sceneBtn;//现场btn

@property (nonatomic, strong) UIView * sliderLine; //btn下边下划线

@property (assign, nonatomic) NSInteger  btnSelected; //选中标识（btn）

@property (nonatomic, strong) UIButton * selectedBtn; //当前选中btn

@property (nonatomic, assign) NSInteger  imageNumber; // 图片的个数

#pragma mark -传输数据
-(void)relayoutWithModelArr:(NSArray *)arr;

#pragma mark -计算View的高度
//-(CGFloat)getViewHeight;

@end
