//
//  ProjectDetailBannerView.m
//  JinZhiT
//
//  Created by Eugene on 16/5/9.
//  Copyright © 2016年 Eugene. All rights reserved.
//

#import "ProjectDetailBannerView.h"
#import "MeasureTool.h"
#define SCROLLVIEWHEIGHT 0.75*SCREENWIDTH
#define btnWidth SCREENWIDTH/3
#define btnHeight  0.1*SCREENWIDTH
#define slederWidth 0.26*SCREENWIDTH

@implementation ProjectDetailBannerView


-(instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        
        [self createUI];
    }
    return self;
    
}

-(void)createUI
{
    //广告栏
    _scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, SCREENWIDTH, SCROLLVIEWHEIGHT)];
    _scrollView.bounces = NO;
    _scrollView.pagingEnabled = YES;
    _scrollView.showsHorizontalScrollIndicator = NO;
    _scrollView.delegate = self;
    [self addSubview:_scrollView];
    
}

/*
#pragma mark -重写selectedBtn的 setter方法
-(void)setBtnSelected:(NSInteger)btnSelected
{
    
}

#pragma mark -下划线位置重置
-(void)setSliderFrame:(NSInteger)offX
{
    
}
#pragma mark -计算View的高度
-(CGFloat)getViewHeight
{
    return 0;
}

#pragma mark -btn点击事件
-(void)btnClick:(UIButton*)btn
{
    _selectedBtn.selected =!_selectedBtn.selected;
    btn.selected = YES;
    [self setSliderFrame:btn.tag];
    _selectedBtn = btn;
    
    //根据btn的tag值 判断是调用代理 还是调整sliderLine的位置
    if (btn.tag == 1000 || btn.tag == 1001 || btn.tag ==1002) {
        if ([self.delegate respondsToSelector:@selector(transportProjectDetailBannerView:andTagValue:)]) {
            [self.delegate transportProjectDetailBannerView:self andTagValue:btn.tag];
        }
    }
    
    
}

*/

#pragma mark -传输数据
-(void)relayoutWithModelArr:(NSArray *)arr
{
    if (arr.count >0) {
        _imageNumber = arr.count;
        NSInteger i =0;
        for (; i<arr.count;i++ ) {
            
            UIButton * imageBtn = [[UIButton alloc]init];
            [imageBtn setTag:100+i];
            [imageBtn setHighlighted:NO];
            [imageBtn setAdjustsImageWhenHighlighted:NO];
            [imageBtn setContentMode:UIViewContentModeScaleAspectFill];
//            [imageBtn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
            //btn加载数据
            
            imageBtn.frame = CGRectMake(0+i*SCREENWIDTH, 0, SCREENWIDTH, SCROLLVIEWHEIGHT);
//            [imageBtn setBackgroundImage:[UIImage imageNamed:@"c9d8be32534701.568974395e076"] forState:UIControlStateNormal];
            [imageBtn sd_setBackgroundImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",arr[i]]] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"placeholderImageDetail"]];
            
            [_scrollView addSubview:imageBtn];
            if (arr.count > 1) {
                
                if (i==0) {
                    UIButton * btn =[[UIButton alloc]init];
                    //btn加载图片
                    [btn setHighlighted:NO];
                    [btn setTag:100+i];
                    [btn setAdjustsImageWhenHighlighted:NO];
                    btn.frame = CGRectMake(arr.count*SCREENWIDTH, 0, SCREENWIDTH, SCROLLVIEWHEIGHT);
                    [imageBtn setContentMode:UIViewContentModeScaleAspectFill];
                    [imageBtn sd_setBackgroundImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",arr[i]]] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"placeholderImageDetail"]];
                    
                    [_scrollView addSubview:btn];
                }
            }
            
        }
        _scrollView.contentSize = CGSizeMake(SCREENWIDTH*i, 0);
//        [self createTimer];
//        [_timer setFireDate:[NSDate distantPast]];
    }
}

#pragma mark -创建定时器
-(void)createTimer
{
    if (_timer == nil) {
        //自动播放 创建
        _timer = [NSTimer scheduledTimerWithTimeInterval:3 target:self selector:@selector(runTimer) userInfo:nil repeats:YES];
    }else{
        [_timer setFireDate:[NSDate distantPast]];
    }
}

#pragma mark- 计时器
-(void)runTimer
{
    int page = _scrollView.contentOffset.x/SCREENWIDTH;
    page++;
    [_scrollView setContentOffset:CGPointMake(page*SCREENWIDTH, 0)
                         animated:YES];
}

#pragma mark -scrollView代理方法  页面控制联动
-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    int page =scrollView.contentOffset.x/SCREENWIDTH;
    if (page == _imageNumber) {
        scrollView.contentOffset = CGPointZero;
        
    }
}

-(void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView
{
    int page =scrollView.contentOffset.x/SCREENWIDTH;
    if (page == _imageNumber) {
        scrollView.contentOffset = CGPointZero;
        
    }
}

-(void)nextPage:(NSInteger)page
{
//    int page = _scrollView.contentOffset.x/SCREENWIDTH;
//    page++;
    [_scrollView setContentOffset:CGPointMake(page*SCREENWIDTH, 0)
                         animated:YES];
}
@end
