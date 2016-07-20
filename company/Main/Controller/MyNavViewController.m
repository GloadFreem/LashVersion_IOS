//
//  MyNavViewController.m
//  ChemistsStore
//  Copyright (c) 2015年 Gene. All rights reserved.
//

#import "MyNavViewController.h"

@interface MyNavViewController ()

@end

@implementation MyNavViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //1.设置当有导航栏自动添加64的高度的属性为NO
    self.automaticallyAdjustsScrollViewInsets = NO;

}
#pragma mark -使用时只调用一次 设置一些全局变量
+(void)initialize{
    
    //设置局部状态栏布局样式
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    //设置全局导航栏背景
    [[UINavigationBar appearance] setBackgroundImage:[UIImage imageNamed:@"navBJ"] forBarMetrics:UIBarMetricsDefault];

    
    [[UINavigationBar appearance] setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor whiteColor],NSFontAttributeName:[UIFont boldSystemFontOfSize:20]}];
     
}

@end
