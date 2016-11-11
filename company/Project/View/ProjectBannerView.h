//
//  ProjectBannerView.h
//  JinZhiT
//
//  Created by Eugene on 16/5/11.
//  Copyright © 2016年 Eugene. All rights reserved.
//


//       --------------------------项目首页广告栏----------------------

#import <UIKit/UIKit.h>
#import "ZMProgressView.h"
#import "ProjectBannerListModel.h"
#import "GENEProgressView.h"
#import "SDCycleScrollView.h"

@class ProjectBannerView;
@protocol ProjectBannerViewDelegate <NSObject>

@optional
//代理方法

-(void)transportProjectBannerView:(ProjectBannerView*)view andTagValue:(NSInteger)tagValue;
-(void)clickBannerImage:(ProjectBannerListModel*)model;

@end


@interface ProjectBannerView : UIView<UIScrollViewDelegate>

@property (nonatomic, strong) ProjectBannerListModel *model;
@property (nonatomic, strong) GENEProgressView*progress;

@property (assign, nonatomic) id<ProjectBannerViewDelegate> delegate;

@property (nonatomic, assign) NSTimeInterval animationDuration; // 定义自动滚动的时间间隔
@property (strong, nonatomic) UIScrollView * scrollView;       //滚动视图控制器
@property (strong, nonatomic) NSTimer * timer;                 //定时器
@property (strong, nonatomic) UIPageControl * pageControl;     //页面控制器
@property (strong, nonatomic) UIView * coverView;              //遮盖view
@property (strong, nonatomic) UIImageView * firstBottomImage;  //底层白圈图片
@property (strong, nonatomic) UIImageView * secondBottomImage; //上层橘色圆圈
@property (strong, nonatomic) UILabel * firstLabel;            //项目名字label
@property (strong, nonatomic) UILabel * secondLabel;           //项目简介label
@property (strong, nonatomic) UIButton * leftBtn;              //左边btn
@property (strong, nonatomic) UIButton * rightBtn;             //右边btn

@property (strong, nonatomic) UIView * leftSliderBottomView;   //左边下划线
@property (strong, nonatomic) UIView * rightSliderBottomView;  //右边下划线

@property (strong, nonatomic) UIButton * selectedBtn;          //当前选中btn
@property (assign, nonatomic) NSInteger selectedNum;           //选中标识

//@property (nonatomic, strong) SDCycleScrollView *bannerView;
@property (nonatomic, strong) NSMutableArray *bannerUrlArray;    //图片链接数组
@property (nonatomic, strong) NSMutableArray *bannerModelArray;  //模型数组


@property (nonatomic, assign) NSInteger imageCount;
//数据数组
@property (nonatomic, strong) NSArray *modelArray;

@property (nonatomic, assign) BOOL isFirst;


-(void)relayoutWithModelArray:(NSArray*)array;                 // 加载数据
              
/**
 *  暂停滚动
 */
- (void)pauseScroll;

/**
 *  恢复滚动
 */
- (void)restoreTheScroll;

@end
