//
//  MainViewController.m
//  JinZhiT
//
//  Created by Eugene on 16/5/3.
//  Copyright © 2016年 Eugene. All rights reserved.
//

#import "MainViewController.h"

#import "ProjectViewController.h"
#import "InvestViewController.h"
#import "MineViewController.h"
#import "CircleViewController.h"
#import "ActivityViewController.h"
@interface MainViewController ()

@end

@implementation MainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self createViewControllers];
}


-(void)createViewControllers{
    NSMutableArray * unSelectedArray = [[NSMutableArray alloc]initWithObjects:[UIImage imageNamed:@"project .png"],[UIImage imageNamed:@"invest.png"],[UIImage imageNamed:@"Circle.png"],[UIImage imageNamed:@"activity.png"],nil];
    
    NSMutableArray * selectedArray = [[NSMutableArray alloc]initWithObjects:[UIImage imageNamed:@"project_selected .png"],[UIImage imageNamed:@"invest_selected.png"],[UIImage imageNamed:@"Circle_selected.png"], [UIImage imageNamed:@"activity_selected.png"],nil];
    
    NSMutableArray * titles = [[NSMutableArray alloc]initWithObjects:@"项目",@"投资人",@"圈子",@"活动", nil];
    
    ProjectViewController * project = [[ProjectViewController alloc]init];
    UINavigationController * navProject = [[UINavigationController alloc]initWithRootViewController:project];
    
    InvestViewController * invest = [[InvestViewController alloc]init];
    UINavigationController * navInvest = [[UINavigationController alloc]initWithRootViewController:invest];
    
    CircleViewController * circle =[[CircleViewController alloc]init];
    UINavigationController * navCircle =[[UINavigationController alloc]initWithRootViewController:circle];
    
    ActivityViewController * activity = [[ActivityViewController alloc]init];
    UINavigationController * navActivity = [[UINavigationController alloc]initWithRootViewController:activity];
    
    self.tabBar = [[JTabBarController alloc]initWithTabBarSelectedImages:selectedArray normalImages:unSelectedArray titles:titles];
    self.tabBar.showCenterItem = YES;
    self.tabBar.centerItemImage = [UIImage imageNamed:@"mine.png"];
    self.tabBar.viewControllers = @[navProject,navInvest,navCircle,navActivity];
    self.tabBar.textColor = [UIColor redColor];
    
    self.tabBar.centerViewController = [[MineViewController alloc]init];
    
}
@end
