//
//  DiscoverViewController.m
//  company
//
//  Created by Eugene on 2016/10/15.
//  Copyright © 2016年 Eugene. All rights reserved.
//

#import "DiscoverViewController.h"
#import "InvestViewController.h"
#import "CircleViewController.h"
#import "SDCycleScrollView.h"
#import "ProjectBannerModel.h"
#import "ProjectBannerListModel.h"
#import "ProjectLetterViewController.h"

#define HASMESSAGE @"requestHasMessageInfo"
@interface DiscoverViewController ()<SDCycleScrollViewDelegate>

@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UIView *circleEnter;
@property (nonatomic, strong) UIView *investEnter;
@property (nonatomic, strong) SDCycleScrollView *bannerView;
@property (nonatomic, strong) NSMutableArray *bannerUrlArray;
@property (nonatomic, strong) NSMutableArray *bannerModelArray;
@property (nonatomic, assign) BOOL hasMessage;
@property (nonatomic, strong) UIButton *letterBtn;
@property (nonatomic, copy) NSString *hasMessagePartner;

@end

@implementation DiscoverViewController

-(NSMutableArray *)bannerUrlArray
{
    if (!_bannerUrlArray) {
        
        NSMutableArray *bannerUrlArray = [NSMutableArray array];
        _bannerUrlArray = bannerUrlArray;
    }
    return _bannerUrlArray;
}

-(NSMutableArray *)bannerModelArray
{
    if (_bannerModelArray) {
        NSMutableArray *bannerModelArray = [NSMutableArray array];
        _bannerModelArray = bannerModelArray;
    }
    return _bannerModelArray;
}

-(SDCycleScrollView *)bannerView
{
    if (!_bannerView) {
        
        SDCycleScrollView *bannerView = [SDCycleScrollView cycleScrollViewWithFrame:CGRectMake(0, 200, SCREENWIDTH, 150) imageURLStringsGroup:_bannerUrlArray];
        bannerView.delegate = self;
        bannerView.pageControlStyle = SDCycleScrollViewPageContolStyleClassic;
        bannerView.showPageControl = YES;
        bannerView.bannerImageViewContentMode = UIViewContentModeScaleToFill;
        bannerView.placeholderImage = [UIImage imageNamed:@"placeholderImageDetail"];
        bannerView.pageControlAliment = SDCycleScrollViewPageContolAlimentRight;
        bannerView.currentPageDotColor = orangeColor;
        bannerView.pageDotColor = [UIColor whiteColor];
//        bannerView.pageControlDotSize = CGSizeMake(5, 5);
        bannerView.autoScrollTimeInterval = 3;
        bannerView.infiniteLoop = YES;
        bannerView.autoScroll = YES;
        _bannerView = bannerView;
    }
    return _bannerView;
}

/** 点击图片回调 */
- (void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didSelectItemAtIndex:(NSInteger)index
{
//    NSLog(@"点击了第%ld张图片(long)",index);
}
-(UIScrollView *)scrollView
{
    if (!_scrollView) {
        UIScrollView *scrollView = [[UIScrollView alloc]initWithFrame:self.view.bounds];
        scrollView.showsVerticalScrollIndicator = NO;
        scrollView.showsHorizontalScrollIndicator = NO;
        scrollView.backgroundColor = color(244, 245, 246, 1);
        [self.view addSubview:scrollView];
        _scrollView = scrollView;
    }
    return _scrollView;
}

-(UIView *)circleEnter
{
    if (!_circleEnter) {
        UIView *circleEnter = [UIView new];
        [circleEnter setBackgroundColor:[UIColor whiteColor]];
        [_scrollView addSubview:circleEnter];
        [circleEnter mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(_scrollView.mas_left);
            make.top.mas_equalTo(20*HEIGHTCONFIG);
            make.width.mas_equalTo(SCREENWIDTH);
            make.height.mas_equalTo(50*HEIGHTCONFIG);
        }];
        
        UIImageView *iconImage = [UIImageView new];
        iconImage.image = [UIImage imageNamed:@"discover_circle.png"];
        iconImage.contentMode = UIViewContentModeScaleAspectFit;
        [circleEnter addSubview:iconImage];
        [iconImage  mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(20*WIDTHCONFIG);
            make.centerY.mas_equalTo(circleEnter.mas_centerY);
        }];
        
        UILabel *title = [UILabel new];
        title.text = @"圈子";
        title.font = BGFont(17);
        title.textColor = color(32, 32, 32, 1);
        [title sizeToFit];
        title.textAlignment = NSTextAlignmentLeft;
        [circleEnter addSubview:title];
        [title mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(iconImage.mas_right).offset(10*WIDTHCONFIG);
            make.height.mas_equalTo(20);
            make.centerY.mas_equalTo(iconImage.mas_centerY);
        }];
        
        UIImageView *arrowImage = [UIImageView new];
        arrowImage.image = [UIImage imageNamed:@"discover_right_arrow.png"];
        arrowImage.contentMode = UIViewContentModeScaleAspectFit;
        [circleEnter addSubview:arrowImage];
        [arrowImage mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(-17*WIDTHCONFIG);
            make.centerY.mas_equalTo(iconImage.mas_centerY);
        }];
        
        UIButton *clickBtn = [UIButton new];
        clickBtn.tag = 1;
        clickBtn.backgroundColor = [UIColor clearColor];
        [clickBtn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
        [circleEnter addSubview:clickBtn];
        [clickBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.view.mas_left);
            make.top.mas_equalTo(self.view.mas_top);
            make.right.mas_equalTo(self.view.right);
            make.bottom.mas_equalTo(self.view.bottom);
        }];
        _circleEnter = circleEnter;
    }
    return _circleEnter;
}
#pragma mark - 进入详情
-(void)btnClick:(UIButton *)btn
{
    if (btn.tag == 1) {
        CircleViewController *circle = [[CircleViewController alloc]init];
        circle.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:circle animated:YES];
    }
    if (btn.tag == 2) {
        InvestViewController *invest = [[InvestViewController alloc]init];
        invest.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:invest animated:YES];
    }
}

-(UIView *)investEnter
{
    if (!_investEnter) {
        UIView *investEnter = [UIView new];
        [investEnter setBackgroundColor:[UIColor whiteColor]];
        [_scrollView addSubview:investEnter];
        [investEnter mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(_scrollView.mas_left);
            make.top.mas_equalTo(_circleEnter.mas_bottom).offset(15*HEIGHTCONFIG);
            make.width.mas_equalTo(SCREENWIDTH);
            make.height.mas_equalTo(50*HEIGHTCONFIG);
        }];
        
        UIImageView *iconImage = [UIImageView new];
        iconImage.image = [UIImage imageNamed:@"discover_invest.png"];
        iconImage.contentMode = UIViewContentModeScaleAspectFit;
        [investEnter addSubview:iconImage];
        [iconImage  mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(20*WIDTHCONFIG);
            make.centerY.mas_equalTo(investEnter.mas_centerY);
        }];
        
        UILabel *title = [UILabel new];
        title.text = @"投资人";
        title.font = BGFont(17);
        title.textColor = color(32, 32, 32, 1);
        [title sizeToFit];
        title.textAlignment = NSTextAlignmentLeft;
        [investEnter addSubview:title];
        [title mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(iconImage.mas_right).offset(10*WIDTHCONFIG);
            make.height.mas_equalTo(20);
            make.centerY.mas_equalTo(iconImage.mas_centerY);
        }];
        
        UIImageView *arrowImage = [UIImageView new];
        arrowImage.image = [UIImage imageNamed:@"discover_right_arrow.png"];
        arrowImage.contentMode = UIViewContentModeScaleAspectFit;
        [investEnter addSubview:arrowImage];
        [arrowImage mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(-17*WIDTHCONFIG);
            make.centerY.mas_equalTo(iconImage.mas_centerY);
        }];
        
        UIButton *clickBtn = [UIButton new];
        clickBtn.tag = 2;
        clickBtn.backgroundColor = [UIColor clearColor];
        [clickBtn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
        [investEnter addSubview:clickBtn];
        [clickBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(0);
            make.top.mas_equalTo(0);
            make.right.mas_equalTo(0);
            make.bottom.mas_equalTo(0);
        }];
        
        _investEnter = investEnter;
    }
    return _investEnter;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(setLetterStatus:) name:@"setLetterStatus" object:nil];
    //站内信
    self.hasMessagePartner = [TDUtil encryKeyWithMD5:KEY action:HASMESSAGE];
    //先从数据库加载 没有数据  则进行数据请求
//    NSArray *bannerArray = [self getDataFromBaseTable:BANNERTABLE];
//    if (bannerArray.count) {
//        [self analysisBannerData:bannerArray];
//    }
//    NSLog(@"打印个数%@",_bannerUrlArray);
    [self createUI];
}
#pragma mark----------------解析banner数据-----------------
-(void)analysisBannerData:(NSArray*)array
{
    if (_bannerModelArray.count) {
        [_bannerModelArray removeAllObjects];
    }
    NSArray *bannerModelArray = [ProjectBannerModel mj_objectArrayWithKeyValuesArray:array];
    for (NSInteger i = 0; i < bannerModelArray.count; i ++) {
        ProjectBannerModel *baseModel = bannerModelArray[i];
        ProjectBannerListModel *listModel = [ProjectBannerListModel new];
        listModel.type = baseModel.type;
        listModel.image = baseModel.body.image;
        listModel.url = baseModel.body.url;
        listModel.desc = baseModel.body.desc;
        listModel.bannerId = baseModel.body.bannerId;
        listModel.name = baseModel.body.name;
        if ([baseModel.type isEqualToString:@"Project"]) {
            listModel.industoryType = baseModel.extr.industoryType;
            listModel.status = baseModel.extr.financestatus.name;
            listModel.projectId = baseModel.extr.projectId;
            if (baseModel.extr.roadshows.count) {
                BannerRoadshows *roadshows = baseModel.extr.roadshows[0];
                BannerRoadshowplan *roadshowplan = roadshows.roadshowplan;
                listModel.financedMount = roadshowplan.financedMount;
                listModel.financeTotal = roadshowplan.financeTotal;
            }
            
        }
//        NSLog(@"打印图片---%@",listModel.image);
        [self.bannerUrlArray addObject:listModel.image];
        [self.bannerModelArray addObject:listModel];
        //            NSLog(@"打印数组个数---%ld",_bannerModelArray.count);
    }
    //搭建banner
//    [self setBanner];
}

-(void)setNav
{
    UIButton * letterBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    letterBtn.tag = 0;
    //通过判断返回数据状态来决定背景图片
    [letterBtn setBackgroundImage:[UIImage imageNamed:@"message"] forState:UIControlStateNormal];
    letterBtn.size = letterBtn.currentBackgroundImage.size;
    [letterBtn addTarget:self action:@selector(buttonCilck:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:letterBtn];
    _letterBtn = letterBtn;
}

-(void)buttonCilck:(UIButton *)button
{
    if (button.tag == 0) {
        //改变已读
        [_letterBtn setBackgroundImage:[UIImage imageNamed:@"message"] forState:UIControlStateNormal];
        
        ProjectLetterViewController *letter = [ProjectLetterViewController new];
        letter.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:letter animated:YES];
        
    }
}
#pragma mark-------------------站内信通知信息----------------------
-(void)setLetterStatus:(NSNotification*)notification
{
    //    UIButton * letterBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    //    letterBtn.tag = 0;
    if (notification) {
        _hasMessage = YES;
        NSLog(@"通知设置的");
    }
    
    //通过判断返回数据状态来决定背景图片
    //    [letterBtn setBackgroundImage:[UIImage imageNamed:@"message"] forState:UIControlStateNormal];
    if (_hasMessage) {//message_new@2x
        [_letterBtn setBackgroundImage:[UIImage imageNamed:@"message_new"] forState:UIControlStateNormal];
    }
    
    //    letterBtn.size = letterBtn.currentBackgroundImage.size;
    //    [letterBtn addTarget:self action:@selector(buttonCilck:) forControlEvents:UIControlEventTouchUpInside];
    //    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:letterBtn];
    //    _letterBtn = letterBtn;
}

-(void)createUI
{
    self.navigationItem.title = @"发现";
    [self setNav];
    //设置站内信状态
    [self setLetterStatus:nil];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self loadMessage];
    });
    
    [self.view addSubview:self.scrollView];
    
    [_scrollView addSubview:self.circleEnter];
    [_scrollView addSubview:self.investEnter];
//    [_scrollView addSubview:self.bannerView];
    
}

#pragma mark--------------------是否站内信未读--------------------
-(void)loadMessage
{
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:KEY,@"key",self.hasMessagePartner,@"partner", nil];

    [[EUNetWorkTool shareTool] POST:JZT_URL(REQUEST_HASMESSAGE_INFO) parameters:dic progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSDictionary *dic = responseObject;
//        NSLog(@"%@",dic);
        if ([dic[@"status"] integerValue] == 200) {
            NSMutableDictionary *data = [NSMutableDictionary dictionaryWithDictionary:dic[@"data"]];
            _hasMessage = [[data objectForKey:@"flag"] boolValue];
            if (_hasMessage) {//message_new@2x
                [_letterBtn setBackgroundImage:[UIImage imageNamed:@"message_new"] forState:UIControlStateNormal];
//                NSLog(@"下载数据有新的");
            }
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
    }];
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark- 视图即将显示
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    self.tabBarController.tabBar.hidden = NO;
    
    [self.navigationController.navigationBar setHidden:NO];
    
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent animated:NO];
    self.navigationController.navigationBar.translucent=NO;
    
}


@end
