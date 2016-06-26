//
//  ProjectDetailInvestVC.m
//  JinZhiT
//
//  Created by Eugene on 16/6/2.
//  Copyright © 2016年 Eugene. All rights reserved.
//

#import "ProjectDetailInvestVC.h"

@interface ProjectDetailInvestVC ()<UITextFieldDelegate>
{
    UITextField *_textField;
    UIButton *_followBtn;
    UIButton *_leadBtn;
    UIButton *_payBtn;
    UILabel *_textLabel;
}
@end

@implementation ProjectDetailInvestVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setNav];
    [self setup];
}

-(void)setNav
{
    self.navigationItem.title = @"认投项目";
    UIButton * leftback = [UIButton buttonWithType:UIButtonTypeCustom];
    [leftback setBackgroundImage:[UIImage imageNamed:@"leftBack"] forState:UIControlStateNormal];
    leftback.tag = 0;
    leftback.size = leftback.currentBackgroundImage.size;
    [leftback addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:leftback] ;
}
-(void)setup
{
    UILabel *remindLabel = [UILabel new];
    remindLabel.text = @"请输入认投金额";
    remindLabel.textColor = [UIColor blackColor];
    remindLabel.font = BGFont(16);
    remindLabel.textAlignment = NSTextAlignmentLeft;
    [self.view addSubview:remindLabel];
    remindLabel.sd_layout
    .leftSpaceToView(self.view, 24)
    .topSpaceToView(self.view, 29)
    .heightIs(16);
    [remindLabel setSingleLineAutoResizeWithMaxWidth:180];
    
    _textField = [UITextField new];
    _textField.delegate = self;
    _textField.font = BGFont(16);
    _textField.textAlignment = NSTextAlignmentLeft;
    _textField.placeholder = @"最小单位为 （万）";
    _textField.clearButtonMode = UITextFieldViewModeWhileEditing;
    _textField.keyboardType = UIKeyboardTypeNumberPad;
    _textField.borderStyle = UITextBorderStyleBezel;
    
    UILabel *rightLabel = [UILabel new];
    rightLabel.text = @"万";
    rightLabel.textColor = orangeColor;
    rightLabel.font = BGFont(16);
    rightLabel.textAlignment = NSTextAlignmentCenter;
    rightLabel.frame = CGRectMake(0, 0, 18, 18);
    _textField.rightView = rightLabel;
    _textField.rightViewMode = UITextFieldViewModeAlways;
    [self.view addSubview:_textField];
    _textField.sd_layout
    .leftSpaceToView(self.view, 24)
    .topSpaceToView(remindLabel, 9)
    .heightIs(44)
    .rightSpaceToView(self.view, 72);
    
    _followBtn = [UIButton new];
    _followBtn.backgroundColor = orangeColor;
    [_followBtn setTitle:@"跟投" forState:UIControlStateNormal];
    _followBtn.titleLabel.font = BGFont(15);
    [_followBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.view addSubview:_followBtn];
    _followBtn.sd_layout
    .leftSpaceToView(_textField, 0)
    .topSpaceToView(remindLabel, 9)
    .heightIs(44)
    .widthIs(48);
    
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc]initWithString:@"温馨提示：\n1、此处领投，跟投仅为用户意向，待项目达成后项目方会协同各方确定最为合适的领投方；\n2、特别注意：投资金额后面的单位为“万”"];
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc]init];
    [paragraphStyle setLineSpacing:13];
    [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, attributedString.length)];
    
    _textLabel = [UILabel new];
    _textLabel.numberOfLines = 4;
    _textLabel.font = BGFont(12);
    _textLabel.textAlignment = NSTextAlignmentLeft;
    _textLabel.textColor = color74;
    _textLabel.attributedText = attributedString;
    [self.view addSubview:_textLabel];
    _textLabel.sd_layout
    .leftEqualToView(_textField)
    .rightEqualToView(_followBtn)
    .topSpaceToView(_textField, 33)
    .autoHeightRatio(0);
    
    _payBtn = [UIButton new];
    [_payBtn setTag:5];
    [_payBtn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    [_payBtn setBackgroundColor:orangeColor];
    [_payBtn setTitle:@"立即支付" forState:UIControlStateNormal];
    [_payBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    _payBtn.titleLabel.font = BGFont(16);
    _payBtn.layer.cornerRadius = 5;
    _payBtn.layer.masksToBounds = YES;
    [self.view addSubview:_payBtn];
    _payBtn.sd_layout
    .centerXEqualToView(self.view)
    .bottomSpaceToView(self.view, 67)
    .widthIs(300)
    .heightIs(44);
}

#pragma mark -textFieldDelegate


-(void)btnClick:(UIButton*)btn
{
    if (btn.tag == 0) {
        [self.navigationController popViewControllerAnimated:YES];
    }
    
    if (btn.tag == 5) {
        NSLog(@"立即支付");
    }
}
@end
