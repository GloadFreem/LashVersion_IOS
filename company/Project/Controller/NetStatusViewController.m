//
//  NetStatusViewController.m
//  company
//
//  Created by Eugene on 16/8/20.
//  Copyright © 2016年 Eugene. All rights reserved.
//

#import "NetStatusViewController.h"

@interface NetStatusViewController ()

@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *subTitleLabel;
@property (nonatomic, strong) UILabel *contentLabel;
@property (nonatomic, strong) UILabel *secondTitleLabel;
@property (nonatomic, strong) UILabel *secondContentLabel;

@end

@implementation NetStatusViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    [self setupNav];
}

-(void)setupNav
{
    UIButton * leftback = [UIButton buttonWithType:UIButtonTypeCustom];
    [leftback setImage:[UIImage imageNamed:@"leftBack"] forState:UIControlStateNormal];
    
    leftback.size = CGSizeMake(80, 30);
    leftback.imageEdgeInsets = UIEdgeInsetsMake(0, -60, 0, 0);
    leftback.titleLabel.text = @"返回";
    [leftback.titleLabel setTextColor:[UIColor whiteColor]];
    leftback.titleLabel.font = BGFont(18);
    [leftback addTarget:self action:@selector(leftBack) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:leftback] ;
    self.navigationItem.title = @"未能连接到互联网";
}

-(void)createUI
{
    _titleLabel = [UILabel new];
    _titleLabel.textColor = [UIColor blackColor];
    _titleLabel.font = [UIFont boldSystemFontOfSize:20];
    _titleLabel.textAlignment = NSTextAlignmentLeft;
    _titleLabel.text = @"您的设备未启用移动网络或Wi-Fi网络";
    [self.view addSubview:_titleLabel];
    
    UIView *contentView = self.view;
    
    _titleLabel.sd_layout
    .leftSpaceToView(contentView,20)
    .topSpaceToView(contentView,40)
    .heightIs(22);
    [_titleLabel setSingleLineAutoResizeWithMaxWidth:300];
    
    _subTitleLabel = [UILabel new];
    _subTitleLabel.textColor = color47;
    _subTitleLabel.font = BGFont(16);
    _subTitleLabel.textAlignment = NSTextAlignmentLeft;
    _subTitleLabel.text = @"如需要连接到互联网，可以参照以下方法：";
    [self.view addSubview:_subTitleLabel];
    _subTitleLabel.sd_layout
    .leftEqualToView(_titleLabel)
    .topSpaceToView(_titleLabel,40)
    .heightIs(17);
    [_subTitleLabel setSingleLineAutoResizeWithMaxWidth:300];
    
    _contentLabel = [UILabel new];
    _contentLabel.textColor = color47;
    _contentLabel.font = BGFont(16);
    _contentLabel.textAlignment = NSTextAlignmentLeft;
    _contentLabel.numberOfLines = 0;
    [self.view addSubview:_contentLabel];
    _contentLabel.sd_layout
    .topSpaceToView(_subTitleLabel,18)
    .leftEqualToView(_titleLabel)
    .rightSpaceToView(contentView,20)
    .autoHeightRatio(0);
    
    NSString *str = @"在设备的“设置”-“Wi-Fi网络”设置面板中选择一个可用的Wi-Fi热点接入。\n在设备的“设置”-“通用”-“网络”设置面板中启用蜂窝移动数据（启用后运营商可能会收取数据通信费用）。";
    
    [TDUtil setLabelMutableText:_contentLabel content:str lineSpacing:3 headIndent:0];
    
    _secondTitleLabel = [UILabel new];
    _secondTitleLabel.textColor = color47;
    _contentLabel.font = BGFont(16);
    _contentLabel.textAlignment = NSTextAlignmentLeft;
    _contentLabel.text = @"如果您已接入Wi-Fi网络：";
    [self.view addSubview:_secondTitleLabel];
    _secondTitleLabel.sd_layout
    .leftEqualToView(_titleLabel)
    .topSpaceToView(_contentLabel,50)
    .heightIs(16);
    [_secondTitleLabel setSingleLineAutoResizeWithMaxWidth:300];
    
    _secondContentLabel = [UILabel new];
    _secondContentLabel.textColor = color47;
    _secondContentLabel.textAlignment = NSTextAlignmentLeft;
    _secondContentLabel.font = BGFont(16);
    _secondContentLabel.numberOfLines = 0;
    NSString *string = @"请检查您所连接的Wi-Fi热点是否已接入互联网，或该热点是否允许您的设备访问互联网";
    [TDUtil setLabelMutableText:_secondContentLabel content:string lineSpacing:3 headIndent:0];
    [self.view addSubview:_secondContentLabel];
    _secondContentLabel.sd_layout
    .leftEqualToView(_titleLabel)
    .topSpaceToView(_secondTitleLabel,18)
    .rightSpaceToView(contentView, 20)
    .autoHeightRatio(0);
    
    
    
}
-(void)leftBack
{
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController.navigationBar setHidden:NO];
    
    UIWindow *window = [[[UIApplication sharedApplication] delegate] window];
    UINavigationController *nav = (UINavigationController*)window.rootViewController;
    JTabBarController * tabBarController;
    for (UIViewController *vc in nav.viewControllers) {
        if ([vc isKindOfClass:JTabBarController.class]) {
            tabBarController = (JTabBarController*)vc;
            [tabBarController tabBarHidden:YES animated:NO];
        }
    }
    
    for (UIViewController *vc in self.navigationController.viewControllers) {
        if ([vc isKindOfClass:JTabBarController.class]) {
            tabBarController = (JTabBarController*)vc;
            [tabBarController tabBarHidden:YES animated:NO];
        }
    }
    
    AppDelegate * delegate =(AppDelegate*)[UIApplication sharedApplication].delegate;
    
    [delegate.tabBar tabBarHidden:YES animated:NO];
    
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
