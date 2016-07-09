//
//  InvestWebViewController.m
//  company
//
//  Created by Eugene on 16/6/14.
//  Copyright © 2016年 Eugene. All rights reserved.
//

#import "InvestWebViewController.h"

@interface InvestWebViewController ()<UIWebViewDelegate>
@property (strong, nonatomic) UIWebView * webView;
@end

@implementation InvestWebViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    _webView  =[[UIWebView alloc]initWithFrame:self.view.frame];
    [self setUpNavBar];
    [self startLoadDetailData];
}

#pragma mark- 设置导航栏
-(void)setUpNavBar
{
    
    self.view.backgroundColor = colorGray;
    UIButton * leftback = [UIButton buttonWithType:UIButtonTypeCustom];
    leftback.tag = 0;
    [leftback setImage:[UIImage imageNamed:@"leftBack"] forState:UIControlStateNormal];
    leftback.size = CGSizeMake(80, 30);
    leftback.imageEdgeInsets = UIEdgeInsetsMake(0, -60, 0, 0);
    [leftback addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:leftback];
}

-(void)btnClick:(UIButton*)btn
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
    [self.view addSubview:_webView];
}


-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    AppDelegate * delegate =(AppDelegate*)[UIApplication sharedApplication].delegate;
    
    [delegate.tabBar tabBarHidden:YES animated:NO];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
