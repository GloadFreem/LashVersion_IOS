//
//  PingTaiWebViewController.m
//  company
//
//  Created by Eugene on 16/6/25.
//  Copyright © 2016年 Eugene. All rights reserved.
//

#import "PingTaiWebViewController.h"
#import "UIImage+GIF.h"
@interface PingTaiWebViewController ()<UIWebViewDelegate>
@property (strong, nonatomic) UIWebView * webView;
@property (strong, nonatomic) UIView *gifView;
@property (strong, nonatomic) UIImageView *gifImageView;
@end

@implementation PingTaiWebViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self.view setBackgroundColor:[UIColor whiteColor]];
    
    [self setNav];
    _webView  =[[UIWebView alloc]initWithFrame:CGRectMake(0, 0, SCREENWIDTH, SCREENHEIGHT-64)];
    _webView.delegate = self;
    _webView.scrollView.bounces = NO;
    [_webView scalesPageToFit];
    [_webView sizeToFit];
    _webView.backgroundColor = [UIColor whiteColor];
    _webView.opaque = NO;
    [self.view addSubview:_webView];
    //加载视图区域
    self.loadingViewFrame = _webView.frame;
    
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


-(void)webViewDidStartLoad:(UIWebView *)webView
{
    if (webView == self.webView) {
        self.startLoading = YES;
    }
}

-(void)webViewDidFinishLoad:(UIWebView *)webView
{
    if (webView == self.webView) {
        self.startLoading = NO;
    }
    [_webView layoutIfNeeded];
}

-(void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    if (webView == self.webView) {
        self.startLoading = YES;
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
    
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];

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
