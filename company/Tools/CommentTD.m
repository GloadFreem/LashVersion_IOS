//
//  CommentTD.m
//  company
//
//  Created by Eugene on 16/7/28.
//  Copyright © 2016年 Eugene. All rights reserved.
//

#import "CommentTD.h"

@implementation CommentTD


+(JTabBarController*)createViewControllers{
    NSMutableArray * unSelectedArray = [[NSMutableArray alloc]initWithObjects:[UIImage imageNamed:@"project.png"],[UIImage imageNamed:@"invest.png"],[UIImage imageNamed:@"Circle.png"],[UIImage imageNamed:@"activity.png"],nil];
    
    NSMutableArray * selectedArray = [[NSMutableArray alloc]initWithObjects:[UIImage imageNamed:@"project_selected .png"],[UIImage imageNamed:@"invest_selected.png"],[UIImage imageNamed:@"Circle_selected.png"], [UIImage imageNamed:@"activity_selected.png"],nil];
    
    NSMutableArray * titles = [[NSMutableArray alloc]initWithObjects:@"项目",@"投资人",@"圈子",@"活动", nil];
    
    ProjectViewController * project = [[ProjectViewController alloc]init];
    MyNavViewController * navProject = [[MyNavViewController alloc]initWithRootViewController:project];
    
    InvestViewController * invest = [[InvestViewController alloc]init];
    MyNavViewController * navInvest = [[MyNavViewController alloc]initWithRootViewController:invest];
    
    CircleViewController * circle =[[CircleViewController alloc]init];
    MyNavViewController * navCircle =[[MyNavViewController alloc]initWithRootViewController:circle];
    
    ActivityViewController * activityVC = [[ActivityViewController alloc]init];
    MyNavViewController * navActivity = [[MyNavViewController alloc]initWithRootViewController:activityVC];
    
    JTabBarController *tabBar = [[JTabBarController alloc]initWithTabBarSelectedImages:selectedArray normalImages:unSelectedArray titles:titles];
    tabBar.showCenterItem = YES;
    tabBar.centerItemImage = [UIImage imageNamed:@"mine.png"];
    tabBar.viewControllers = @[navProject,navInvest,navCircle,navActivity];
    tabBar.textColor = orangeColor;
    MyNavViewController *navMine = [[MyNavViewController alloc]initWithRootViewController:[[MineViewController alloc]init]];
    tabBar.centerViewController = navMine;
    
    return tabBar;
    
}
@end
