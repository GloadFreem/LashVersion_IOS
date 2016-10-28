//
//  NetStatusViewController.m
//  company
//
//  Created by Eugene on 16/8/20.
//  Copyright © 2016年 Eugene. All rights reserved.
//

#import "NetStatusViewController.h"

@interface NetStatusViewController ()

@property (nonatomic, strong) UILabel *firstTitleLabel;
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
    [self createUI];
}

-(void)setupNav
{
    UIButton * leftback = [UIButton buttonWithType:UIButtonTypeCustom];
    [leftback setImage:[UIImage imageNamed:@"leftBack"] forState:UIControlStateNormal];
    
    leftback.size = CGSizeMake(80*WIDTHCONFIG, 30);
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
    _firstTitleLabel = [UILabel new];
    _firstTitleLabel.textColor = [UIColor blackColor];
    _firstTitleLabel.font = [UIFont boldSystemFontOfSize:18*WIDTHCONFIG];
    _firstTitleLabel.textAlignment = NSTextAlignmentLeft;
    _firstTitleLabel.text = @"您的设备未启用移动网络或Wi-Fi网络";
    [self.view addSubview:_firstTitleLabel];
    
    UIView *contentView = self.view;
    
    _firstTitleLabel.sd_layout
    .leftSpaceToView(contentView,20)
    .topSpaceToView(contentView,25)
    .heightIs(20);
    [_firstTitleLabel setSingleLineAutoResizeWithMaxWidth:320*WIDTHCONFIG];
    
    _subTitleLabel = [UILabel new];
    _subTitleLabel.textColor = color47;
    _subTitleLabel.font = [UIFont boldSystemFontOfSize:14*WIDTHCONFIG];
    _subTitleLabel.textAlignment = NSTextAlignmentLeft;
    _subTitleLabel.text = @"如需要连接到互联网，可以参照以下方法：";
    [self.view addSubview:_subTitleLabel];
    _subTitleLabel.sd_layout
    .leftEqualToView(_firstTitleLabel)
    .topSpaceToView(_firstTitleLabel,15)
    .heightIs(15);
    [_subTitleLabel setSingleLineAutoResizeWithMaxWidth:300*WIDTHCONFIG];
    
    _contentLabel = [UILabel new];
    _contentLabel.textColor = color47;
    _contentLabel.font = BGFont(14*WIDTHCONFIG);
    _contentLabel.textAlignment = NSTextAlignmentLeft;
    [self.view addSubview:_contentLabel];
    
    NSString *str = @"在设备的“设置”-“Wi-Fi网络”设置面板中选择一个可用的Wi-Fi热点接入。\n在设备的“设置”-“通用”-“网络”设置面板中启用蜂窝移动数据(启用后运营商可能会收取数据通信费用)。";

//    _contentLabel.text = str;
    
    _contentLabel.sd_layout
    .topSpaceToView(_subTitleLabel,8)
    .leftEqualToView(_firstTitleLabel)
    .rightSpaceToView(contentView,20)
    .autoHeightRatio(0);
    [TDUtil setLabelMutableText:_contentLabel content:str lineSpacing:3 headIndent:0];
    _contentLabel.isAttributedContent = YES;
    
    
    _secondTitleLabel = [UILabel new];
    _secondTitleLabel.textColor = color47;
    _secondTitleLabel.font = [UIFont boldSystemFontOfSize:14*WIDTHCONFIG];
    _secondTitleLabel.textAlignment = NSTextAlignmentLeft;
    _secondTitleLabel.text = @"如果您已接入Wi-Fi网络：";
    [self.view addSubview:_secondTitleLabel];
    
    _secondTitleLabel.sd_layout
    .leftEqualToView(_firstTitleLabel)
    .topSpaceToView(_contentLabel,15)
    .heightIs(15);
    [_secondTitleLabel setSingleLineAutoResizeWithMaxWidth:300*WIDTHCONFIG];
    
    _secondContentLabel = [UILabel new];
    _secondContentLabel.textColor = color47;
    _secondContentLabel.textAlignment = NSTextAlignmentLeft;
    _secondContentLabel.font = BGFont(14*WIDTHCONFIG);
    _secondContentLabel.numberOfLines = 0;
    NSString *string = @"请检查您所连接的Wi-Fi热点是否已接入互联网，或该热点是否允许您的设备访问互联网。";
    
    [self.view addSubview:_secondContentLabel];
    _secondContentLabel.sd_layout
    .leftEqualToView(_secondTitleLabel)
    .topSpaceToView(_secondTitleLabel,8)
    .rightSpaceToView(contentView,20)
    .autoHeightRatio(0);
    [TDUtil setLabelMutableText:_secondContentLabel content:string lineSpacing:3 headIndent:0];
    _secondContentLabel.isAttributedContent = YES;
    
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
