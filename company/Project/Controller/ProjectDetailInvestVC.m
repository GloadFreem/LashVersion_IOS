//
//  ProjectDetailInvestVC.m
//  JinZhiT
//
//  Created by Eugene on 16/6/2.
//  Copyright © 2016年 Eugene. All rights reserved.
//

#import "ProjectDetailInvestVC.h"
#import "ProjectInvestSuccessController.h"
#import "LoadingBlackView.h"
#define SIGNVERIFY @"signVerify"
#define INVESTPROJECT @"requestInvestProject"
@interface ProjectDetailInvestVC ()<UITextFieldDelegate,UIAlertViewDelegate>
{
    UITextField *_textField;
    UIView *_btnView;
    UIButton *_firstBtn;
    UIButton *_secondBtn;
    UIButton *_payBtn;
    UILabel *_textLabel;
    NSMutableArray *_titleArray;
    NSMutableArray *_flagArray;
    NSInteger _flag;
    NSString *_request;
    CGFloat _cha;
    
    PayStatus payStatus;
    
}
@property (nonatomic, strong) LoadingBlackView *loadingBlackView;
@property (nonatomic, copy) NSString *signPartner;
@property (nonatomic, copy) NSString *investpartner;

@end

@implementation ProjectDetailInvestVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    //获得partner
    self.signPartner = [TDUtil encryKeyWithMD5:KEY action:SIGNVERIFY];
    self.investpartner  = [TDUtil encryKeyWithMD5:KEY action:INVESTPROJECT];
    
    [self.view setBackgroundColor:[UIColor whiteColor]];
    _flag = 0;
    payStatus  = PayStatusNormal;
    [self setNav];
    [self setup];
    //设置加载视图范围
    self.loadingViewFrame = self.view.bounds;
}

-(void)setNav
{
    self.navigationItem.title = @"认投项目";
    UIButton * leftback = [UIButton buttonWithType:UIButtonTypeCustom];
    [leftback setImage:[UIImage imageNamed:@"leftBack"] forState:UIControlStateNormal];
    [leftback addTarget:self action:@selector(leftback) forControlEvents:UIControlEventTouchUpInside];
    leftback.size = CGSizeMake(80, 30);
    leftback.imageEdgeInsets = UIEdgeInsetsMake(0, -60, 0, 0);
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:leftback];
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
    _textField.keyboardType = UIKeyboardTypeNumbersAndPunctuation;
//    _textField.borderStyle = UITextBorderStyleBezel;
    _textField.keyboardType = UITextBorderStyleRoundedRect;
    _textField.layer.borderWidth = 0.5;
//    _textField.layer.borderColor = [UIColor lightTextColor].CGColor;
    _textField.layer.borderColor = [TDUtil colorWithHexString:@"aaaaaa"].CGColor;
    _textField.returnKeyType = UIReturnKeyDone;
    
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
    
    _titleArray = [NSMutableArray arrayWithObjects:@"跟投",@"领投", nil];
    _flagArray = [NSMutableArray arrayWithObjects:@"1",@"0", nil];
    _firstBtn = [UIButton new];
    _firstBtn.backgroundColor = orangeColor;
    _firstBtn.tag = 0;
    [_firstBtn setTitle:_titleArray[0] forState:UIControlStateNormal];
    _firstBtn.titleLabel.font = BGFont(15);
    [_firstBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_firstBtn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_firstBtn];
    _firstBtn.sd_layout
    .leftSpaceToView(_textField,0)
    .topSpaceToView(remindLabel,9)
    .heightIs(44)
    .widthIs(48);
    
    _secondBtn = [UIButton new];
    _secondBtn.tag = 1;
    _secondBtn.backgroundColor = orangeColor;
    [_secondBtn setTitle:_titleArray[1] forState:UIControlStateNormal];
    _secondBtn.titleLabel.font = BGFont(15);
    [_secondBtn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    [_secondBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    //默认不显示
    [_secondBtn setHidden:YES];
    [self.view addSubview:_secondBtn];
    _secondBtn.sd_layout
    .leftEqualToView(_firstBtn)
    .topSpaceToView(_firstBtn,0)
    .widthIs(48)
    .heightIs(44);
    
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc]initWithString:@"温馨提示：\n1、此处领投，跟投仅为用户意向，待项目达成后项目方会协同各方确定最为合适的领投方；\n2、特别注意：投资金额后面的单位为“万”"];
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc]init];
    [paragraphStyle setLineSpacing:13];
    [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, attributedString.length)];
    
    _textLabel = [UILabel new];
    _textLabel.font = BGFont(12);
    _textLabel.textAlignment = NSTextAlignmentLeft;
    _textLabel.textColor = color74;
    _textLabel.attributedText = attributedString;
    _textLabel.isAttributedContent = YES;
    [self.view addSubview:_textLabel];
    _textLabel.sd_layout
    .leftEqualToView(_textField)
    .rightEqualToView(_firstBtn)
    .topSpaceToView(_textField, 33)
    .autoHeightRatio(0);
    
    _payBtn = [UIButton new];
    [_payBtn setTag:5];
    [_payBtn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    [_payBtn setBackgroundColor:orangeColor];
    [_payBtn setTitle:@"确定" forState:UIControlStateNormal];
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

#pragma mark-------------------------btnClickAction--------------------------------
-(void)leftback
{
    if (self.startLoading) {
        return;
    }
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)btnClick:(UIButton*)btn
{
    if (btn.tag == 0) {
        _secondBtn.hidden = !_secondBtn.hidden;
        
    }
    if (btn.tag == 1) {
        NSString *title = _titleArray[0];
        _titleArray[0] = _titleArray[1];
        _titleArray[1] = title;
        NSString *flag = _flagArray[0];
        _flagArray[0] = _flagArray[1];
        _flagArray[1] = flag;
        
        [_firstBtn setTitle:_titleArray[0] forState:UIControlStateNormal];
        [_secondBtn setTitle:_titleArray[1] forState:UIControlStateNormal];
//        NSLog(@"点击切换按钮");
        _secondBtn.hidden = YES;
        
    }
    if (btn.tag == 5) {
        if (_textField.text.length) {
            
            if ( [TDUtil isPureInt:_textField.text] || [TDUtil isPureFloat:_textField.text]) {
                if ([_textField.text floatValue] * 10000 < _limitAmount) {
                    [[DialogUtil sharedInstance]showDlg:self.view textOnly:[NSString stringWithFormat:@"投资金额不能少于%f",_limitAmount]];
                    return;
                }
#pragma mark----------------------进入易宝流程-------------------------
//                NSLog(@"立即支付-----%f",_limitAmount);
                
//                if (!_isClick) {
//                    [self setBtnStatus];
//                    
//                    [self gotoInvest];
//                
//                }
                if (!self.startLoading) {
                    [self gotoInvest];
                }
                
            }else{
            [[DialogUtil sharedInstance]showDlg:self.view textOnly:@"请输入正确的投资金额"];
            }
            
        }else{
        [[DialogUtil sharedInstance]showDlg:self.view textOnly:@"投资金额不能为空"];
        }
    }
    btn.selected = !btn.selected;
    
//    NSLog(@"打印领投还是跟投标识---%@",_flagArray[0]);
}
-(void)setBtnStatus
{
    _isClick = YES;
}

-(void)addBlackView
{
    
    if (!_loadingBlackView) {
        _loadingBlackView = [[LoadingBlackView alloc]initWithFrame:self.loadingViewFrame];
        [self.view addSubview:_loadingBlackView];
    }
}
-(void)closeBlackView
{
    if (_loadingBlackView) {
        [_loadingBlackView removeFromSuperview];
        _loadingBlackView = nil;
        for (UIView *view in self.view.subviews) {
            if ([view isKindOfClass:[LoadingBlackView class]]) {
                [view removeFromSuperview];
            }
        }
    }
    //        NSLog(@"yichu");
}

-(void)gotoInvest
{
    [self addBlackView];
    self.startLoading = YES;
    self.isTransparent = YES;
    
    NSMutableDictionary * dic = [NSMutableDictionary new];
    NSString* mount =_textField.text;
    float money = [mount floatValue];
    mount = [NSString stringWithFormat:@"%.2f",money * 10000];
    [dic setObject:mount forKey:@"amount"];
    [dic setValue:[NSString stringWithFormat:@"%ld",(long)self.projectId] forKey:@"projectId"];

    [dic setValue:@"" forKey:@"tradeCode"];
    
    [dic setValue:_flagArray[0] forKey:@"flag"];
    
    [self.httpUtil getDataFromAPIWithOps:REQUESTINVESTPROJECT postParam:dic type:0 delegate:self sel:@selector(requestFinialSubmmmit:)];
}

-(void)requestFinialSubmmmit:(ASIHTTPRequest *)request
{
    NSString *jsonString = [TDUtil convertGBKDataToUTF8String:request.responseData];
//        NSLog(@"返回:%@",jsonString);
    NSMutableDictionary* jsonDic = [jsonString JSONValue];
    
    if(jsonDic!=nil)
    {
        NSString* status = [jsonDic valueForKey:@"status"];
        if ([status intValue] == 200) {
            [self closeBlackView];
             self.startLoading = NO;
            ProjectInvestSuccessController *success = [[ProjectInvestSuccessController alloc] init];
            [self.navigationController pushViewController:success animated:YES];
            
            
        
        }else{
            
            [self closeBlackView];
            self.startLoading = NO;
            [self showAlertView:[jsonDic valueForKey:@"message"]];
        }
        
    }
}

-(void)requestFailed:(ASIHTTPRequest *)request
{
//    NSString *jsonString = [TDUtil convertGBKDataToUTF8String:request.responseData];
//    NSLog(@"返回:%@",jsonString);
//    self.isNetRequestError = YES;
    [self closeBlackView];
    self.startLoading = NO;
    [self showAlertView:@"网络异常"];
}

-(void)showAlertView:(NSString *)message
{
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"温馨提示" message:message preferredStyle:UIAlertControllerStyleAlert];
    __block ProjectDetailInvestVC* blockSelf = self;
    
    UIAlertAction *cancleAction = [UIAlertAction actionWithTitle:@"放弃" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
//        [blockSelf.navigationController popViewControllerAnimated:YES];
        [self.navigationController popViewControllerAnimated:YES];
    }];
    
    [cancleAction setValue:color(71, 71, 71, 1) forKey:@"_titleTextColor"];
    
    
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"再试一试" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        //        [blockSelf btnCertain:nil];
        [blockSelf gotoInvest];
    }];
    
    [alertController addAction:cancleAction];
    [alertController addAction:okAction];
    
    [self presentViewController:alertController animated:YES completion:nil];
}

#pragma mark -------------------------textFiledDelegate-----------------------------
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return NO;
}
- (void)textFieldDidBeginEditing:(UITextField *)textField{
//    NSLog(@"开始编辑");
}
- (void)textFieldDidEndEditing:(UITextField *)textField{
    
    if (![textField.text isEqualToString:@""]) {
        
        _textField.text = textField.text;
    }
//    NSLog(@"结束编辑");
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    _isClick = NO;
}
-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    self.startLoading = NO;
}

-(void)dealloc
{
    [self cancleRequest];
}
@end
