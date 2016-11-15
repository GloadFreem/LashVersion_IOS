//
//  MyNavViewController.m
//  ChemistsStore
//  Copyright (c) 2015年 Gene. All rights reserved.
//

#import "MyNavViewController.h"

@interface MyNavViewController ()<UINavigationControllerDelegate>
// 记录push标志
@property (nonatomic, getter=isPushing) BOOL pushing;
@end

@implementation MyNavViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.delegate = self;
    //1.设置当有导航栏自动添加64的高度的属性为NO
//    self.automaticallyAdjustsScrollViewInsets = NO;
    
    //实现全屏滑动返回
    
//    id target = self.interactivePopGestureRecognizer.delegate;
//#pragma clang diagnostic push
//#pragma clang diagnostic ignored "-Wundeclared-selector"
//    UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:target action:@selector(handleNavigationTransition:)];
//#pragma clang diagnostic pop
//    [self.view addGestureRecognizer:pan];
//    
//    // 取消边缘滑动手势
//    self.interactivePopGestureRecognizer.enabled = NO;
//    
//    pan.delegate = self;

}
#pragma mark -使用时只调用一次 设置一些全局变量
+(void)initialize{
    
    //设置局部状态栏布局样式
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    //设置全局导航栏背景
    [[UINavigationBar appearance] setBackgroundImage:[UIImage imageNamed:@"navBJ"] forBarMetrics:UIBarMetricsDefault];
    //设置光标颜色
    [[UITextField appearance] setTintColor:[UIColor whiteColor]];
    [[UITextView appearance] setTintColor:[UIColor blackColor]];
    
    [[UINavigationBar appearance] setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor whiteColor],NSFontAttributeName:[UIFont boldSystemFontOfSize:20]}];
     
}

#pragma mark ---- <UIGestureRecognizerDelegate>


//- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch
//{
//    // 判断下当前是不是在根控制器
//    return self.childViewControllers.count > 1;
//}

#pragma mark ---- <非根控制器隐藏底部tabbar>
//- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated{
//    if (self.viewControllers.count > 0) {
//        
//        viewController.hidesBottomBarWhenPushed = YES;
//    }
//    [super pushViewController:viewController animated:animated];
//    
//}

- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    if (self.pushing == YES) {
//        NSLog(@"被拦截");
        return;
    } else {
//        NSLog(@"push");
        self.pushing = YES;
    }
    
    [super pushViewController:viewController animated:animated];
}


#pragma mark - UINavigationControllerDelegate
-(void)navigationController:(UINavigationController *)navigationController didShowViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    self.pushing = NO;
}

-(UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

@end
