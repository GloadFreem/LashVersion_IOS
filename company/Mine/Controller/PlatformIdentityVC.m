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
    
    [_moreLabel setHidden:YES];
    [_moreView setHidden:YES];
    [self setupNav];
    [self setModel];
}

-(void)setModel
{
    _introduceLabel.numberOfLines = 0;
    NSLog(@"%@",_identifyType);
    _identifyLabel.text = _identifyType;
    if ([_identifyType isEqualToString:@"项目方"]) {
        _iconImage.image = [UIImage imageNamed:@"icon_project.png"];
        _introduceLabel.text = @"具有优质项目标的，想通过释放股权进行融资，有梦想的创业者、企业家。";
    }
    if ([_identifyType isEqualToString:@"个人投资者"]) {
        _iconImage.image = [UIImage imageNamed:@"touziren-icon"];
        _introduceLabel.text = @"具有投资意识、投资能力，正在寻找股权投资标的的高净值投资人及企业家。";
    }
    if ([_identifyType isEqualToString:@"机构投资者"]) {
        _iconImage.image = [UIImage imageNamed:@"iconfont-jigouT"];
        _introduceLabel.text = @"国内外优秀VC/PE机构、创投机构、专业投资人、金指投领投机构及领投人。";
    }
    if ([_identifyType isEqualToString:@"智囊团"]) {
        _iconImage.image =[UIImage imageNamed:@"iconfont-danaoT"];
        _introduceLabel.text = @"著名投资人、企业家及创业者、证券从业者、会计师、律师、企业管理咨询师等，能为企业快速发展提供建设性意见和建议的“牛”人。";
    }
}
#pragma mark -设置导航栏
-(void)setupNav
{
    UIButton * leftback = [UIButton buttonWithType:UIButtonTypeCustom];
    [leftback setImage:[UIImage imageNamed:@"leftBack"] forState:UIControlStateNormal];
    leftback.size = CGSizeMake(80, 30);
    leftback.imageEdgeInsets = UIEdgeInsetsMake(0, -60, 0, 0);
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

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self.navigationController.navigationBar setHidden:NO];
}

#pragma mark- 返回按钮
-(void)leftBack:(UIButton*)btn
{
    [self.navigationController popViewControllerAnimated:YES];
}

@end
