//
//  PlatformIdentityVC.m
//  JinZhiT
//
//  Created by Eugene on 16/5/25.
//  Copyright © 2016年 Eugene. All rights reserved.
//

#import "PlatformIdentityVC.h"
#import "PerfectViewController.h"

@interface PlatformIdentityVC ()


@end

@implementation PlatformIdentityVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self setupNav];
    [self setModel];
}

-(void)setModel
{
    _identifyLabel.text = _identifyType;
    if ([_identifyType isEqualToString:@"项目方"]) {
        _iconImage.image = [UIImage imageNamed:@"icon_project.png"];
    }
    if ([_identifyType isEqualToString:@"投资人"]) {
        _iconImage.image = [UIImage imageNamed:@"touziren-icon"];
    }
    if ([_identifyType isEqualToString:@"投资机构"]) {
        _iconImage.image = [UIImage imageNamed:@"iconfont-jigouT"];
    }
    if ([_identifyType isEqualToString:@"智囊团"]) {
        _iconImage.image =[UIImage imageNamed:@"iconfont-danaoT"];
    }
}
#pragma mark -设置导航栏
-(void)setupNav
{
    UIButton * leftback = [UIButton buttonWithType:UIButtonTypeCustom];
    [leftback setBackgroundImage:[UIImage imageNamed:@"leftBack"] forState:UIControlStateNormal];
    leftback.size = leftback.currentBackgroundImage.size;
    [leftback addTarget:self action:@selector(leftBack:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:leftback] ;
    self.navigationItem.title = @"平台身份";
}

#pragma mark------增加身份-------
- (IBAction)addIdentify:(UIButton *)sender
{
    PerfectViewController *perfect = [PerfectViewController new];
    [self.navigationController.navigationBar setHidden: YES];
    [self.navigationController pushViewController:perfect animated:YES];
    
}




#pragma mark- 返回按钮
-(void)leftBack:(UIButton*)btn
{
    [self.navigationController popViewControllerAnimated:YES];
}

@end
