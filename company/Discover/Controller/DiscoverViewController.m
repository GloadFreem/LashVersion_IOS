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

@interface DiscoverViewController ()

@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UIView *circleEnter;
@property (nonatomic, strong) UIView *investEnter;

@end

@implementation DiscoverViewController

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
        [self.navigationController pushViewController:circle animated:YES];
    }
    if (btn.tag == 2) {
        InvestViewController *invest = [[InvestViewController alloc]init];
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
    
    [self createUI];
}


-(void)createUI
{
    self.navigationItem.title = @"发现";
    [self.view addSubview:self.scrollView];
    
    [_scrollView addSubview:self.circleEnter];
    [_scrollView addSubview:self.investEnter];
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark- 视图即将显示
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self.navigationController.navigationBar setHidden:NO];
    
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent animated:NO];
    self.navigationController.navigationBar.translucent=NO;
    
    UIWindow *window = [[[UIApplication sharedApplication] delegate] window];
    UINavigationController *nav = (UINavigationController*)window.rootViewController;
    JTabBarController * tabBarController;
    for (UIViewController *vc in nav.viewControllers) {
        if ([vc isKindOfClass:JTabBarController.class]) {
            tabBarController = (JTabBarController*)vc;
            [tabBarController tabBarHidden:NO animated:NO];
        }
    }
    
    for (UIViewController *vc in self.navigationController.viewControllers) {
        if ([vc isKindOfClass:JTabBarController.class]) {
            tabBarController = (JTabBarController*)vc;
            [tabBarController tabBarHidden:NO animated:NO];
        }
    }
    
    //不隐藏tabbar
    AppDelegate * delegate =(AppDelegate*)[UIApplication sharedApplication].delegate;
    
    [delegate.tabBar tabBarHidden:NO animated:NO];
    
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
