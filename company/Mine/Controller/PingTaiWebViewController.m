//
//  PingTaiWebViewController.m
//  company
//
//  Created by Eugene on 16/6/25.
//  Copyright © 2016年 Eugene. All rights reserved.
//

#import "PingTaiWebViewController.h"

@interface PingTaiWebViewController ()<UIWebViewDelegate>
@property (strong, nonatomic) UIWebView * webView;
@property (strong, nonatomic) UIView *gifView;
@property (strong, nonatomic) UIImageView *gifImageView;
@end

@implementation PingTaiWebViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    
    [self.view setBackgroundColor:[UIColor whiteColor]];
    
    [self setNav];
    
    _webView  =[[UIWebView alloc]initWithFrame:self.view.frame];
    _webView.delegate =self;
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
    _gifView.backgroundColor = [UIColor blackColor];
    _gifView.alpha = 0.3;
    [self.view addSubview:_gifView];
    
    
    _gifImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 174, 174)];
    _gifImageView.center = self.view.center;
    UIImage *image = [UIImage sd_animatedGIFNamed:@"jinzhit001"];
    _gifImageView.image = image;
    [self.view addSubview:_gifImageView];
    
}
#pragma mark----移除loadingView
-(void)removeLoadingView
{
    [_gifImageView removeFromSuperview];
    [_gifView removeFromSuperview];
    [self.view addSubview:_webView];
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
//        [SVProgressHUD showWithStatus:@"加载中..."];
        
    }
}

-(void)webViewDidFinishLoad:(UIWebView *)webView
{
    if (webView == self.webView) {
//        [SVProgressHUD dismiss];
        [self removeLoadingView];
        
    }
    
}

-(void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    if (webView == self.webView) {
//        [SVProgressHUD dismiss];
        [self removeLoadingView];
    }
    [[DialogUtil sharedInstance]showDlg:self.view textOnly:@"加载失败"];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self createLoadingView];    //创建加载动画
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
//    [SVProgressHUD dismiss];
    [self removeLoadingView];
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
