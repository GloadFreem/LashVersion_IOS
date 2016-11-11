//
//  JTabBarController.m
//  JinZhiT
//
//  Created by Eugene on 16/5/3.
//  Copyright © 2016年 Eugene. All rights reserved.
//

#import "JTabBarController.h"
#import "MeasureTool.h"
#import "ProjectViewController.h"

#import "MineViewController.h"
#import "BaseTabBar.h"
#import "ActivityViewController.h"
#import "DiscoverViewController.h"
#import "TankViewController.h"

@interface JTabBarController()<UITabBarControllerDelegate>

@property (nonatomic, strong) MyNavViewController *myNav;

@end


@implementation JTabBarController


-(void)viewDidLoad{
    [super viewDidLoad];
    
//    self.delegate = self;
//    _myNav = [[MyNavViewController  alloc] init];
    [self initChildViewControllers];
    
    BaseTabBar *tabBar = [[BaseTabBar alloc] init];
    tabBar.delegate = self;
    //替换系统tabbar
//    [self setValue:tabBar forKeyPath:@"tabBar"];
    [self.tabBar setBackgroundImage:[UIImage imageNamed:@"dock_bg"]];
//    [self.tabBar setBackgroundColor:[UIColor clearColor]];
    [self.tabBar setBarStyle:UIBarStyleBlackOpaque];
    
//    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(pushController:) name:@"pushController" object:nil];
}

//初始化自控制器
-(void)initChildViewControllers
{
    [self setupController:[[ProjectViewController alloc]init] image:@"project.png" selectedImage:@"project_selected.png" title:@"项目"];
    [self setupController:[[DiscoverViewController alloc]init] image:@"discover_tab.png" selectedImage:@"discover_tab_sel.png" title:@"发现"];
    
    [self setupController:[[UIViewController alloc]init] image:@"tabBar_mine" selectedImage:@"tabBar_mine" title:@""];
    
    [self setupController:[[ActivityViewController alloc]init] image:@"activity.png" selectedImage:@"activity_selected.png" title:@"活动"];
    [self setupController:[[TankViewController alloc]init] image:@"thinktank_tab.png" selectedImage:@"thinktank_tab_sel.png" title:@"智库"];
}

//设置控制器
-(void)setupController:(UIViewController *)childVc image:(NSString *)image selectedImage:(NSString *)selectedImage title:(NSString *)title
{
    UIViewController *viewVc = childVc;
    UIImage *imageP = [UIImage imageNamed:image];
    imageP = [imageP imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    viewVc.tabBarItem.image = imageP;
    UIImage *imageS = [UIImage imageNamed:selectedImage];
    imageS = [imageS imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    viewVc.tabBarItem.selectedImage = imageS;
    viewVc.tabBarItem.title = title;
    if ([title isEqualToString:@""]) {
        viewVc.tabBarItem.imageInsets = UIEdgeInsetsMake(-6, 0, 6, 0);
        viewVc.view.backgroundColor = [UIColor whiteColor];
    }
    MyNavViewController *navVc = [[MyNavViewController alloc]initWithRootViewController:viewVc];
    [self addChildViewController:navVc];
}

//- (void)tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController
//{
////    NSLog(@"选择器");
////    [self getPresentedViewController];
//    _myNav =(MyNavViewController *) viewController;
////    NSLog(@"打印选择控制器---%@",[viewController class]);
//    
//}
//-(BOOL)tabBarController:(UITabBarController *)tabBarController shouldSelectViewController:(UIViewController *)viewController
//{
//    
//    if ([tabBarController.childViewControllers indexOfObject:viewController] == tabBarController.childViewControllers.count - 3) {
//        MineViewController *mine = [[MineViewController alloc]init];
//        MyNavViewController *navVc = [[MyNavViewController alloc]initWithRootViewController:mine];
//        //选择显示界面
//        [self presentViewController:navVc animated:YES completion:nil];
//        _myNav = navVc;
////        NSLog(@"推出的控制器---%@",[navVc class]);
//        return NO;
//    }
//    return YES;
//}

- (UIViewController *)getPresentedViewController
{
    UIViewController *appRootVC = [UIApplication sharedApplication].keyWindow.rootViewController;
    UIViewController *topVC = appRootVC;
    if (topVC.presentedViewController) {
        topVC = topVC.presentedViewController;
    }
//    NSLog(@"打印当前控制器---%@",[topVC class]);
    return topVC;
}


-(void)pushController:(NSNotification*)notification
{
    NSDictionary * dic = notification.userInfo;
    UIViewController * controller = [dic valueForKey:@"controller"];
    controller.title = [dic valueForKey:@"title"];
//    [self.navigationController pushViewController:controller animated:YES];
    [_myNav pushViewController:controller animated:YES];
//    NSLog(@"推送来了没");
}


@end

