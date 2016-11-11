//
//  ProjectInvestSuccessController.m
//  company
//
//  Created by Eugene on 2016/11/8.
//  Copyright © 2016年 Eugene. All rights reserved.
//

#import "ProjectInvestSuccessController.h"
#import "ProjectDetailController.h"
#import "ProjectDetailInvestVC.h"
@interface ProjectInvestSuccessController ()

@property (nonatomic, strong) UIImageView *imageView;

@property (nonatomic, strong) UIButton *certainBtn;

@property (nonatomic, strong) UIImageView *backgroundImage;
@end

@implementation ProjectInvestSuccessController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setupNav];
    
    [self setup];
}

-(void)setupNav
{
    self.navigationItem.title = @"完成";
    UIButton *btn = [UIButton new];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:btn];
}

-(void)setup
{
    self.view.backgroundColor = [TDUtil colorWithHexString:@"f5f5f5"];
    
    UIImageView *backgroundImage = [UIImageView new];
    backgroundImage.contentMode = UIViewContentModeScaleToFill;
    backgroundImage.image = [UIImage imageNamed:@"invest_bg"];
//    [self.view addSubview:backgroundImage];
    _backgroundImage = backgroundImage;
//    [backgroundImage mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.right.top.bottom.mas_equalTo(0);
//    }];
    
    UIImageView *imageView = [UIImageView new];
    imageView.contentMode = UIViewContentModeScaleToFill;
    imageView.image = [UIImage imageNamed:@"invest_sucess"];
    [self.view addSubview:imageView];
    _imageView = imageView;
    [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(50*WIDTHCONFIG);
        make.top.mas_equalTo(87*HEIGHTCONFIG);
        make.right.mas_equalTo(-50*WIDTHCONFIG);
        make.height.mas_equalTo(281*HEIGHTCONFIG);
    }];
    
    UIButton *certainBtn = [UIButton new];
    [certainBtn addTarget:self action:@selector(certain) forControlEvents:UIControlEventTouchUpInside];
    [certainBtn setTitle:@"确定" forState:UIControlStateNormal];
    [certainBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [certainBtn setBackgroundColor:[TDUtil colorWithHexString:@"ff6700"]];
    [certainBtn.titleLabel setFont:[UIFont systemFontOfSize:18*HEIGHTCONFIG]];
    certainBtn.layer.cornerRadius = 5;
    certainBtn.layer.masksToBounds = YES;
    [self.view addSubview:certainBtn];
    _certainBtn = certainBtn;
    [certainBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(40*HEIGHTCONFIG);
        make.left.mas_equalTo(imageView);
        make.right.mas_equalTo(imageView);
        make.top.mas_equalTo(imageView.mas_bottom).offset(100*HEIGHTCONFIG);
    }];
    
    
}

-(void)certain
{
    for (UIViewController *VC in self.navigationController.viewControllers) {
        if ([VC isKindOfClass:[ProjectDetailInvestVC class]]) {
            [VC removeFromParentViewController];
        }
        if ([VC isKindOfClass:[ProjectDetailController class]]) {
            [self.navigationController popToViewController:VC animated:YES];
        }
    }    
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
