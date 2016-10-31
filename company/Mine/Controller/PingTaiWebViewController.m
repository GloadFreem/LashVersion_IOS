//
//  PingTaiWebViewController.m
//  company
//
//  Created by Eugene on 16/6/25.
//  Copyright © 2016年 Eugene. All rights reserved.
//

#import "PingTaiWebViewController.h"
#import "UIImage+GIF.h"
#import "LoadingBlackView.h"

@interface PingTaiWebViewController ()<UIWebViewDelegate>
@property (strong, nonatomic) UIWebView * webView;
@property (strong, nonatomic) UIView *gifView;
@property (strong, nonatomic) UIImageView *gifImageView;
@property (nonatomic, strong) LoadingBlackView *loadingBlackView;
@end

@implementation PingTaiWebViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self.view setBackgroundColor:[UIColor whiteColor]];
    
    [self setNav];
    _webView  =[[UIWebView alloc]initWithFrame:CGRectMake(0, 0, SCREENWIDTH, SCREENHEIGHT-64)];
//    _webView = [[UIWebView alloc]initWithFrame:self.view.bounds];
    _webView.delegate = self;
    _webView.scrollView.bounces = NO;
    [_webView scalesPageToFit];
    [_webView sizeToFit];
    _webView.backgroundColor = [UIColor whiteColor];
    _webView.opaque = NO;
    [self.view addSubview:_webView];
    
    
    [self startLoadDetailData];
    
}


-(void)setNav
{
    UIButton * leftback = [UIButton buttonWithType:UIButtonTypeCustom];
    [leftback setImage:[UIImage imageNamed:@"leftBack"] forState:UIControlStateNormal];
    leftback.size = CGSizeMake(80, 30);
    leftback.imageEdgeInsets = UIEdgeInsetsMake(0, -60, 0, 0);
    [leftback addTarget:self action:@selector(leftBack) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:leftback] ;
    self.navigationItem.title = self.titleStr;
}
#pragma mark-----创建loadingView
-(void)createLoadingView
{
    _gifView = [[UIView alloc]initWithFrame:self.view.frame];
    _gifView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:_gifView];
    
    _gifImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 150*WIDTHCONFIG, 150*WIDTHCONFIG)];
    _gifImageView.centerX = self.view.centerX;
    _gifImageView.centerY = self.view.centerY - 50;
    UIImage *image = [UIImage sd_animatedGIFNamed:@"loadingView"];
    _gifImageView.image = image;
    [self.view addSubview:_gifImageView];
    
}
#pragma mark----移除loadingView
-(void)removeLoadingView
{
    [_gifImageView removeFromSuperview];
    [_gifView removeFromSuperview];
    
}

-(void)leftBack
{
    [self.webView stopLoading];
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)startLoadDetailData
{
    if (![_url hasPrefix:@"http://"]) {
        NSString * url =[NSString stringWithFormat:@"http://%@",_url];
        [_webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:url]]];
    }else{
        [_webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:_url]]];
    }
    
}
-(void)addBlackView
{
    _loadingBlackView = [[LoadingBlackView alloc]initWithFrame:self.loadingViewFrame];
    [self.view addSubview:_loadingBlackView];
    
}
-(void)closeBlackView
{
    [_loadingBlackView removeFromSuperview];
    for (UIView *view in self.view.subviews) {
        if ([view isKindOfClass:[LoadingBlackView class]]) {
            [view removeFromSuperview];
        }
    }
    //        NSLog(@"yichu");
}

-(void)webViewDidStartLoad:(UIWebView *)webView
{
    if (webView == self.webView) {
        //加载视图区域
        self.loadingViewFrame = _webView.frame;
        [self addBlackView];
        self.startLoading = YES;
        self.isTransparent = YES;
        self.isBlack = YES;
    }
}

-(void)webViewDidFinishLoad:(UIWebView *)webView
{
    if (webView == self.webView) {
        self.startLoading = NO;
        [self closeBlackView];
        [self.webView.scrollView setContentOffset:CGPointZero];
    }
    [_webView layoutIfNeeded];
}

-(void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    if (webView == self.webView) {
        [self closeBlackView];
        self.startLoading = NO;
        self.isNetRequestError = YES;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController.navigationBar setHidden:NO];
    [self.navigationController setNavigationBarHidden:NO];
    
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent animated:NO];
    self.navigationController.navigationBar.translucent=NO;
    
    UIWindow *window = [[[UIApplication sharedApplication] delegate] window];
    UINavigationController *nav = (UINavigationController*)window.rootViewController;
    JTabBarController * tabBarController;
    for (UIViewController *vc in nav.viewControllers) {
        if ([vc isKindOfClass:JTabBarController.class]) {
            tabBarController = (JTabBarController*)vc;
            [tabBarController tabBarHidden:YES animated:NO];
        }
    }
    
    for (UIViewController *vc in self.navigationController.viewControllers) {
        if ([vc isKindOfClass:JTabBarController.class]) {
            tabBarController = (JTabBarController*)vc;
            [tabBarController tabBarHidden:YES animated:NO];
        }
    }
    
    //不隐藏tabbar
    AppDelegate * delegate =(AppDelegate*)[UIApplication sharedApplication].delegate;
    
    [delegate.tabBar tabBarHidden:YES animated:NO];
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self.navigationController setNavigationBarHidden:YES];


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
