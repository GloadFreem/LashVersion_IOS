//
//  MineRingCodeVC.m
//  JinZhiT
//
//  Created by Eugene on 16/5/25.
//  Copyright © 2016年 Eugene. All rights reserved.
//

#import "MineRingCodeVC.h"

@interface MineRingCodeVC ()

@property (weak, nonatomic) IBOutlet UILabel *ringCodeLabel;
@property (weak, nonatomic) IBOutlet UIImageView *iconImage;


@end

@implementation MineRingCodeVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self setupNav];
    _ringCodeLabel.text = _inviteCode;
    
    _iconImage.layer.cornerRadius = 34;
    _iconImage.layer.masksToBounds = YES;
    
    [_iconImage sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",_icon]] placeholderImage:[UIImage new]];
    
}

#pragma mark -设置导航栏
-(void)setupNav
{
    UIButton * leftback = [UIButton buttonWithType:UIButtonTypeCustom];
    [leftback setImage:[UIImage imageNamed:@"leftBack"] forState:UIControlStateNormal];
    leftback.size = CGSizeMake(80, 30);
    leftback.imageEdgeInsets = UIEdgeInsetsMake(0, -20, 0, 0);
    [leftback addTarget:self action:@selector(leftBack:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:leftback] ;
    self.navigationItem.title = @"指环码";
}
#pragma mark- 返回按钮
-(void)leftBack:(UIButton*)btn
{
    [self.navigationController popViewControllerAnimated:YES];
}
- (IBAction)copyBtn:(UIButton *)sender {
    UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
    pasteboard.string = _inviteCode;
    [[DialogUtil sharedInstance]showDlg:self.view textOnly:@"指环码已复制到剪切板"];
}

@end
