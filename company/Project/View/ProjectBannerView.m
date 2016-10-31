//
//  ProjectBannerView.m
//  JinZhiT
//
//  Created by Eugene on 16/5/11.
//  Copyright © 2016年 Eugene. All rights reserved.
//

#import "ProjectBannerView.h"

#import "MeasureTool.h"
#import "NSTimer+Addition.h"
#import "ProjectBannerModel.h"

#define kImageCount self.imageCount

#define kWidth self.frame.size.width
#define kHeight self.frame.size.height

#define kPAGEWIDTH 50
#define kPAGEHEIGHT 5

#define kCOVERHEIGHT 50
#define kLeftSpace 10

@implementation ProjectBannerView

-(instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        _isFirst = YES;
        [self createUI];
    }
    return self;
}

#pragma mark - 自定义布局
-(void)createUI
{
    [self setBackgroundColor:[UIColor whiteColor]];
    //广告栏
    _scrollView = [UIScrollView new];
    _scrollView.bounces = NO;
    _scrollView.pagingEnabled = YES;
    _scrollView.showsHorizontalScrollIndicator = NO;
    _scrollView.delegate = self;
    [self addSubview:_scrollView];
    [_scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.mas_left);
        make.top.mas_equalTo(self.mas_top);
        make.right.mas_equalTo(self.mas_right);
        make.height.mas_equalTo(kHeight - 45);
    }];
    
    //遮盖
    _coverView = [UIView new];
    _coverView.backgroundColor = [UIColor blackColor];
    _coverView.alpha = 0.5;
    [self addSubview:_coverView];
    [_coverView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(_scrollView.mas_left);
        make.right.mas_equalTo(_scrollView.mas_right);
        make.bottom.mas_equalTo(_scrollView.mas_bottom);
        make.height.mas_equalTo(kCOVERHEIGHT);
    }];
    _coverView.hidden = YES;
    
    //圆圈
    UIImage * bottom = [UIImage imageNamed:@"icon-bottom-circle"];
    _firstBottomImage = [[UIImageView alloc]initWithImage:bottom];
    //设置圆角
    _firstBottomImage.layer.cornerRadius = bottom.size.width/2;
    _firstBottomImage.layer.masksToBounds = YES;
    //自适应图片宽高比例
    _firstBottomImage.contentMode = UIViewContentModeScaleAspectFit;
    [self addSubview:_firstBottomImage];
    [_firstBottomImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(kLeftSpace);
        make.width.height.mas_equalTo(46);
        make.bottom.mas_equalTo(_scrollView.mas_bottom).offset(-10);
    }];
    _firstBottomImage.hidden = YES;
    
    //进度条
    _progress = [[GENEProgressView alloc]initWithLineColor:orangeColor loopColor:[UIColor clearColor]];
    _progress.backgroundColor = [UIColor clearColor];
    [self addSubview:_progress];
    [_progress mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(_firstBottomImage.mas_centerX);
        make.centerY.mas_equalTo(_firstBottomImage.mas_centerY);
        make.width.height.mas_equalTo(48);
    }];
    _progress.hidden = YES;
    
    //firstLabel
    _firstLabel = [UILabel new];
    _firstLabel.font = [UIFont systemFontOfSize:17];
    [_firstLabel sizeToFit];
    _firstLabel.textColor = [UIColor whiteColor];
    _firstLabel.textAlignment = NSTextAlignmentLeft;
    [self addSubview:_firstLabel];
    [_firstLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(_firstBottomImage.mas_right).offset(15);
        make.top.mas_equalTo(_coverView.mas_top).offset(8);
        make.height.mas_equalTo(17);
    }];
    
    //第二个label
    _secondLabel = [UILabel new];
    _secondLabel.font =[UIFont systemFontOfSize:12];
    [_secondLabel sizeToFit];
    _secondLabel.textColor = color(217, 217, 217, 1);
    _secondLabel.textAlignment = NSTextAlignmentLeft;
    [self addSubview:_secondLabel];
    [_secondLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(_firstLabel.mas_left);
        make.top.mas_equalTo(_firstLabel.mas_bottom).offset(8);
        make.height.mas_equalTo(12);
        make.right.mas_equalTo(_scrollView.mas_right).offset(-80);
    }];
    
    //第一个button
    _leftBtn = [UIButton new];
    [_leftBtn setTag:20];
    [_leftBtn setTitle:@"路演项目" forState:UIControlStateNormal];
    [_leftBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [_leftBtn setTitleColor:orangeColor forState:UIControlStateSelected];
    _leftBtn.titleLabel.font = [UIFont systemFontOfSize:19];
    [_leftBtn addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    ;
    [_leftBtn setSelected:YES];
    
    _selectedBtn = _leftBtn;
    
    [self addSubview:_leftBtn];
    
    [_leftBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.mas_left);
        make.top.mas_equalTo(_scrollView.mas_bottom);
        make.width.mas_equalTo(SCREENWIDTH/2);
        make.height.mas_equalTo(45);
    }];
    //左边的下划线
    //下划线的宽
    CGFloat sliderWidth = [_leftBtn.titleLabel.text commonStringWidthForFont:19];
    _leftSliderBottomView = [UIView new];
    _leftSliderBottomView.alpha = 0.8;
    [self addSubview:_leftSliderBottomView];
    [_leftSliderBottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(SCREENWIDTH/4 - sliderWidth/2);
        make.height.mas_equalTo(3);
        make.bottom.mas_equalTo(self.mas_bottom);
        make.width.mas_equalTo(sliderWidth);
    }];
    
    //第二个button
    _rightBtn =[UIButton new];
    [_rightBtn setTitle:@"预选项目" forState:UIControlStateNormal];
    [_rightBtn setTag:21];
    [_rightBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [_rightBtn setTitleColor:orangeColor forState:UIControlStateSelected];
    //    [_rightBtn setBackgroundColor:[UIColor blackColor]];
    _rightBtn.titleLabel.font = [UIFont systemFontOfSize:19];
    [_rightBtn addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_rightBtn];
    [_rightBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.mas_right);
        make.width.mas_equalTo(SCREENWIDTH/2);
        make.top.mas_equalTo(_scrollView.mas_bottom);
        make.height.mas_equalTo(45);
    }];
    
    //右边下划线
    _rightSliderBottomView = [UIView new];
    _rightSliderBottomView.alpha = 0.8;
    [self addSubview:_rightSliderBottomView];
    [_rightSliderBottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.mas_right).offset(-(SCREENWIDTH/4 - sliderWidth/2));
        make.bottom.mas_equalTo(self.mas_bottom);
        make.height.mas_equalTo(3);
        make.width.mas_equalTo(sliderWidth);
    }];
    
    //页面控制器
    _pageControl = [UIPageControl new];
    _pageControl. userInteractionEnabled = NO;
    _pageControl.currentPage = 0;
    _pageControl.pageIndicatorTintColor = [UIColor lightGrayColor];
    _pageControl.currentPageIndicatorTintColor = orangeColor;
    [self addSubview:_pageControl];
    [_pageControl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(self.mas_bottom).offset(-55);
        make.right.mas_equalTo(_coverView.mas_right).offset(-18);
        make.width.mas_equalTo(kPAGEWIDTH);
        make.height.mas_equalTo(kPAGEHEIGHT);
    }];
    //设置默认显示btn
    _selectedBtn.tag = 20;
}

#pragma mark -重写setter方法
-(void)setSelectedNum:(NSInteger)selectedNum
{
    _selectedNum = selectedNum;
    [self setColorWithNum:_selectedNum];
}

#pragma mark -设置下划线的颜色
-(void)setColorWithNum:(NSInteger)num
{
    if (num == 20) {
        [_leftSliderBottomView setBackgroundColor:orangeColor];
        [_rightSliderBottomView setBackgroundColor:[UIColor whiteColor]];
    }else{
        [_leftSliderBottomView setBackgroundColor:[UIColor whiteColor]];
        [_rightSliderBottomView setBackgroundColor:orangeColor];
    }
}

#pragma mark- button点击事件
-(void)buttonClick:(UIButton*)button
{
    _selectedBtn.selected =!_selectedBtn.selected;
    button.selected = YES;
    [self setColorWithNum:button.tag];
    _selectedBtn = button;
    if ([self.delegate respondsToSelector:@selector(transportProjectBannerView:andTagValue:)]){
        [self.delegate transportProjectBannerView:self andTagValue:button.tag];
    }
}

#pragma mark- cell刷新数据
-(void)relayoutWithModelArray:(NSArray *)array
{
    for (id view in _scrollView.subviews) {
        if ([view isKindOfClass:[UIButton class]]) {
            [view removeFromSuperview];
        }
    }
    
    NSInteger i =0;
    for (; i<_imageCount + 2; i++) {
        ProjectBannerListModel *model;
        UIButton * btn = [[UIButton alloc]init];
        [btn setAdjustsImageWhenHighlighted:NO];
        [btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
        btn.frame = CGRectMake(0+i*kWidth, 0, kWidth, kHeight - 45);
        
        if (i == 0) {
            //第一张 显示最后一张图片
            model = (ProjectBannerListModel*)[array lastObject];
            btn.tag = 1000;
            [btn sd_setBackgroundImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",model.image]] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"placeholderImageDetail"]];
        }else if (i == _imageCount + 1){
            //最后一张  显示 第一张图片
            model = (ProjectBannerListModel*)[array firstObject];
            btn.tag = 1100;
            [btn sd_setBackgroundImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",model.image]] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"placeholderImageDetail"]];
        }else{
            model = (ProjectBannerListModel*)array[i - 1];
            btn.tag = 1000 + i;
            [btn sd_setBackgroundImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",model.image]] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"placeholderImageDetail"]];
        }
        
        [_scrollView addSubview:btn];
    }
    _scrollView.contentSize = CGSizeMake((_imageCount + 2) * kWidth, kHeight - 45);
    // 设置偏移量
    _scrollView.contentOffset = CGPointMake(kWidth, 0);
    [self createTimer];
    
    for (NSInteger i = 0; i < _imageCount + 2; i ++) {
        ProjectBannerListModel *model;
        if (i == 0) {
            model =(ProjectBannerListModel*)[array lastObject];
        }else if (i == _imageCount + 1){
            model  =(ProjectBannerListModel*)[array firstObject];
        }else{
            model  =(ProjectBannerListModel*)array[i - 1];
        }
        if ([model.type isEqualToString:@"Project"]) {
            _coverView.hidden = NO;
            _firstBottomImage.hidden = NO;
//            _pageControl.hidden = NO;
            _firstLabel.hidden = NO;
            _secondLabel.hidden = NO;
            
            _firstLabel.text = model.name;
            _secondLabel.text = model.desc;
            _progress.hidden = NO;
            _progress.title = @"W";
            if (_isFirst) {
               _progress.animatable = YES;
           
            CGFloat finalCount = model.financedMount;
            CGFloat percent = finalCount / model.financeTotal * 100;
            _progress.percent = percent;
            _progress.contentText = [NSString stringWithFormat:@"%ld",(long)model.financeTotal];
            _isFirst = NO;
            }
            
        }else{
            _coverView.hidden = YES;
            _firstBottomImage.hidden = YES;
            _progress.title = @"";
            _progress.contentText = @"";
//            _pageControl.hidden = YES;
            _firstLabel.hidden = YES;
            _secondLabel.hidden = YES;
            _progress.hidden = YES;
        }
    }
    [self layoutSubviews];
}

-(void)setImageCount:(NSInteger)imageCount
{
    _imageCount = imageCount;
    _pageControl.numberOfPages =imageCount;
}
#pragma mark- 创建Timer
-(void)createTimer
{
    if (_timer == nil) {
        _timer = [NSTimer scheduledTimerWithTimeInterval:_animationDuration target:self selector:@selector(autoChangeFrame:) userInfo:nil repeats:YES];
        // 保证在主界面滑动的时候NSTimer也不暂停
        [[NSRunLoop currentRunLoop] addTimer:_timer forMode:NSRunLoopCommonModes];
    }
}
//自动滚动
-(void)autoChangeFrame:(NSTimer*)timer
{
    // 进行纠偏(为了防止出现便宜量在屏幕一半的情况)
    NSInteger currentPage = _scrollView.contentOffset.x/kWidth;
    CGPoint newOffset = CGPointMake(currentPage * kWidth + kWidth, 0);
    [_scrollView setContentOffset:newOffset animated:YES];
//    NSLog(@"视图当前位置---%ld",currentPage);
    [self changeCurrentPageAuto];
}

#pragma mark - 更改UIPageControl的当前指示页（自动滚动的时候）
- (void)changeCurrentPageAuto
{
//    UIPageControl *pageControl = (UIPageControl *)[self viewWithTag:20000];
    if (_scrollView.contentOffset.x / kWidth == _imageCount) {
        _pageControl.currentPage = 0;
//        NSLog(@"最后一页");
        
    } else if (_scrollView.contentOffset.x / kWidth == 0) {
        _pageControl.currentPage = _imageCount - 1;
//        NSLog(@"第0页");
    } else {
        _pageControl.currentPage = _scrollView.contentOffset.x / kWidth; // 根据视图偏移的距离，更改pageControl的当前选中的页
//        NSLog(@"当前页");
    }
}

#pragma mark -scrollView 页面控制联动
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    // 首先得到当前的偏移量
    CGPoint currentPoint = scrollView.contentOffset;
    if (currentPoint.x <= kWidth / 2) {
        scrollView.contentOffset = CGPointMake(_imageCount * kWidth + currentPoint.x, 0);
    } else if (currentPoint.x > (_imageCount + 0.5) * kWidth) {
        scrollView.contentOffset = CGPointMake(currentPoint.x - _imageCount * kWidth, 0);
    }
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    [_timer pauseTimer];
}

-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    [_timer resumeTimerAfterTimeInterval:_animationDuration];
    _pageControl.currentPage = _scrollView.contentOffset.x / kWidth - 1; // 根据视图偏移的距离，更改pageControl的当前选中的页
    
    ProjectBannerListModel *model =(ProjectBannerListModel*)_modelArray[_pageControl.currentPage];
    if ([model.type isEqualToString:@"Project"]) {
        _coverView.hidden = NO;
        _firstBottomImage.hidden = NO;
        //        _pageControl.hidden = NO;
        _firstLabel.hidden = NO;
        _secondLabel.hidden = NO;
        
        _firstLabel.text = model.name;
        _secondLabel.text = model.desc;
        _progress.hidden = NO;
        _progress.title = @"W";
        
        if (_isFirst) {
            _progress.animatable = YES;
            
            CGFloat finalCount = model.financedMount;
            CGFloat percent = finalCount / model.financeTotal * 100;
            _progress.percent = percent;
            _progress.contentText = [NSString stringWithFormat:@"%ld",(long)model.financeTotal];
            _isFirst = NO;
        }
        
    }else{
        _coverView.hidden = YES;
        _firstBottomImage.hidden = YES;
        //        _pageControl.hidden = YES;
        _progress.title = @"";
        _progress.contentText = @"";
        _firstLabel.hidden = YES;
        _secondLabel.hidden = YES;
        _progress.hidden = YES;
    }
    [self layoutSubviews];
}
//结束滚动
-(void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView
{
//    _pageControl.currentPage = _scrollView.contentOffset.x / kWidth - 1; // 根据视图偏移的距离，更改pageControl的当前选中的页
    ProjectBannerListModel *model =(ProjectBannerListModel*)_modelArray[_pageControl.currentPage];
    if ([model.type isEqualToString:@"Project"]) {
        _coverView.hidden = NO;
        _firstBottomImage.hidden = NO;
//        _pageControl.hidden = NO;
        _firstLabel.hidden = NO;
        _secondLabel.hidden = NO;
        
        _firstLabel.text = model.name;
        _secondLabel.text = model.desc;
        _progress.hidden = NO;
        _progress.title = @"W";
        
        if (_isFirst) {
            _progress.animatable = YES;
            
            CGFloat finalCount = model.financedMount;
            CGFloat percent = finalCount / model.financeTotal * 100;
            _progress.percent = percent;
            _progress.contentText = [NSString stringWithFormat:@"%ld",(long)model.financeTotal];
            _isFirst = NO;
        }
        
    }else{
        _coverView.hidden = YES;
        _firstBottomImage.hidden = YES;
//        _pageControl.hidden = YES;
        _progress.title = @"";
        _progress.contentText = @"";
        _firstLabel.hidden = YES;
        _secondLabel.hidden = YES;
        _progress.hidden = YES;
    }
    [self layoutSubviews];
    
}
#pragma mark -点击btn事件处理
-(void)btnClick:(UIButton*)btn
{
    ProjectBannerListModel *model;
    if (btn.tag == 1000) {
        model = (ProjectBannerListModel*)[_modelArray lastObject];
    }else if (btn.tag == 1100){
        model = (ProjectBannerListModel*)[_modelArray firstObject];
    }else{
        model = (ProjectBannerListModel*)_modelArray[btn.tag -1 - 1000];
    }
    if ([self.delegate respondsToSelector:@selector(clickBannerImage:)]) {
        [self.delegate clickBannerImage:model];
    }
}

- (void)pauseScroll
{
    [_timer pauseTimer];
}

- (void)restoreTheScroll
{
    [_timer resumeTimerAfterTimeInterval:_animationDuration];
}

- (void)dealloc
{
    [_timer invalidate];
    _timer = nil;
}

@end
