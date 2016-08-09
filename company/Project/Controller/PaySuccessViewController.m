//
//  PaySuccessViewController.m
//  JinZhiTou
//
//  Created by BraveHeart on 16/3/7.
//  Copyright © 2016年 金指投. All rights reserved.
//

#import "PaySuccessViewController.h"
//#import "UserFinialViewController.h"
#import "ProjectDetailInvestVC.h"
#import "YeePayViewController.h"
#import "ProjectDetailController.h"

#import "MineProjectViewController.h"

@implementation PaySuccessViewController
-(void)viewDidLoad
{
    [super viewDidLoad];
    
    //设置标题
//    self.navView.imageView.alpha=1;
//    [self.navView setTitle:@"支付成功"];
//    self.navView.titleLable.textColor=WriteColor;
//    
//    [self.navView.leftButton setImage:nil forState:UIControlStateNormal];
//    [self.navView.leftButton setTitle:@"返回" forState:UIControlStateNormal];
//    [self.navView.leftTouchView addGestureRecognizer:[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(back:)]];
//
    self.navigationItem.title = @"支付成功";
    [self setup];
}

-(void)setup
{
    //1.init
    contentView = [UIScrollView new];
    btnAction = [UIButton new];
    labelContent = [UILabel new];
    imgView = [UIImageView new];
    imgSuccessView = [UIImageView new];
    
    self.titleLabel = [UILabel new];
    self.imgView = [UIImageView new];
    self.imgView.layer.cornerRadius = 30;
    self.imgView.layer.masksToBounds = YES;
    self.subTitleLabel = [UILabel new];
    
    
    //2. addSubView
    [self.view addSubview:contentView];
    
    [contentView addSubview:imgView];
    [contentView addSubview:labelContent];
    [contentView addSubview:imgSuccessView];
    
    //2.添加到视图
    [TDUtil addChildViewToView:contentView childViews:[NSArray arrayWithObjects:self.imgView,self.titleLabel,self.subTitleLabel,btnAction, nil]];
    
    //3.property
    contentView.bounces = YES;
    contentView.backgroundColor = BackColor;
    
    imgView.image = IMAGENAMED(@"paySuccessBG");
    imgView.contentMode = UIViewContentModeScaleAspectFill;
    
    imgSuccessView.image = IMAGENAMED(@"Success");
    
    labelContent.textColor = WriteColor;
    labelContent.font = SYSTEMFONT(18);
    labelContent.textAlignment = NSTextAlignmentCenter;
    
    self.titleLabel.font = SYSTEMFONT(15);
    self.subTitleLabel.font = SYSTEMFONT(12);
    self.titleLabel.textColor = WriteColor;
    self.subTitleLabel.textColor = WriteColor;
    float mount = [DICVFK(self.dataDic, @"mount") floatValue]*10000;
    labelContent.text = STRING(@"¥ %.2f\n恭喜！已支付成功！", mount);
    self.titleLabel.text =self.abbrevName;
    self.subTitleLabel.text = self.fullName;
    [self.imgView sd_setImageWithURL:[NSURL URLWithString:self.startPageImage] placeholderImage:IMAGENAMED(@"test")];
    
    [btnAction setImage:IMAGENAMED(@"paySuccessSure") forState:UIControlStateNormal];
    [btnAction addTarget:self action:@selector(btnAction:) forControlEvents:UIControlEventTouchUpInside];
    
    
    //4.layout
    contentView.sd_layout
    .spaceToSuperView(UIEdgeInsetsMake(kTopBarHeight + kStatusBarHeight, 0, 0, 0));
    
    imgView.sd_layout
    .leftSpaceToView(contentView, 20)
    .rightSpaceToView(contentView, 20)
    .topSpaceToView(contentView, kTopBarHeight + kStatusBarHeight +54);
    
    imgSuccessView.sd_layout
    .widthIs(50)
    .heightIs(50)
    .topSpaceToView(contentView, 80)
    .centerXEqualToView(contentView);
    
    labelContent.sd_layout
    .autoHeightRatio(0)
    .leftSpaceToView(contentView, 20)
    .rightSpaceToView(contentView, 20)
    .topSpaceToView(imgSuccessView, 27);
    
    self.imgView.sd_layout
    .topSpaceToView(labelContent, 30)
    .leftSpaceToView(contentView, 60)
    .widthIs(60)
    .heightIs(60);
    
    self.titleLabel.sd_layout
    .topEqualToView(self.imgView)
    .leftSpaceToView(self.imgView, 12)
    .autoHeightRatio(0);
    
    [self.titleLabel setSingleLineAutoResizeWithMaxWidth:250];
    
    self.subTitleLabel.sd_layout
    .leftEqualToView(self.titleLabel)
    .topSpaceToView(self.titleLabel, 2)
    .autoHeightRatio(0);
    
    [self.subTitleLabel setSingleLineAutoResizeWithMaxWidth:300];
    
    btnAction.sd_layout
    .topSpaceToView(imgView, 150)
    .leftSpaceToView(contentView, 25)
    .rightSpaceToView(contentView, 25)
    .heightIs(40);
    
}

-(void)setDataDic:(NSMutableDictionary *)dataDic
{
    [super setDataDic:dataDic];
}

-(void)btnAction:(id)sender
{
    
    MineProjectViewController *vc = [MineProjectViewController new];
    [self.navigationController pushViewController:vc animated:YES];
    
    for (UIViewController *VC in self.navigationController.viewControllers) {
        if ([VC isKindOfClass:[YeePayViewController class]]) {
            [VC removeFromParentViewController];
        }
        if ([VC isKindOfClass:[ProjectDetailInvestVC class]]) {
            [VC removeFromParentViewController];
        }
        if ([VC isKindOfClass:[ProjectDetailController class]]) {
            [VC removeFromParentViewController];
        }
    }
    
    [self removeFromParentViewController];
}

-(void)back:(id)sender
{
    [self.navigationController popToRootViewControllerAnimated:YES];
}
@end
