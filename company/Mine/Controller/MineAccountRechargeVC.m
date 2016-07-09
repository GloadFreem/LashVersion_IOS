//
//  MineAccountRechargeVC.m
//  company
//
//  Created by Eugene on 16/6/27.
//  Copyright © 2016年 Eugene. All rights reserved.
//

#import "MineAccountRechargeVC.h"
#import "YeePayViewController.h"

#define SIGNVERIFY @"signVerify"

@interface MineAccountRechargeVC ()<UITextFieldDelegate>

@property (nonatomic, strong) UITextField *textField;
@property (nonatomic, strong) UIButton *nextBtn;

@property (nonatomic, copy) NSString *signPartner;
@property (nonatomic, copy) NSString *request;
@property (nonatomic, copy) NSString *tradeCode;
@end

@implementation MineAccountRechargeVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    //获得partner
    self.signPartner = [TDUtil encryKeyWithMD5:KEY action:SIGNVERIFY];
    
    [self setNav];
    [self createUI];
}

-(void)setNav
{
    self.view.backgroundColor = [UIColor whiteColor];
    UIButton * leftback = [UIButton buttonWithType:UIButtonTypeCustom];
    
    [leftback setImage:[UIImage imageNamed:@"leftBack"] forState:UIControlStateNormal];
    leftback.size = CGSizeMake(80, 30);
    leftback.imageEdgeInsets = UIEdgeInsetsMake(0, -60, 0, 0);
    [leftback addTarget:self action:@selector(leftBack) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:leftback] ;
    self.navigationItem.title = @"账户充值";
}
-(void)leftBack
{
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)createUI
{
    [self.view setBackgroundColor:LightGrayColor];
    
    _textField = [UITextField new];
    _textField.borderStyle = UITextBorderStyleNone;
    _textField.backgroundColor = [UIColor whiteColor];
    _textField.delegate = self;
    _textField.placeholder = @"请输入充值金额";
    _textField.textAlignment = NSTextAlignmentLeft;
    _textField.textColor  = color47;
    _textField.font = BGFont(17);
    _textField.keyboardType = UIKeyboardTypeNumberPad;
    _textField.clearButtonMode = UITextFieldViewModeWhileEditing;
    
    UILabel *leftView = [UILabel new];
    leftView.text = @"金额";
    leftView.textColor = [UIColor blackColor];
    leftView.textAlignment = NSTextAlignmentCenter;
    leftView.font = BGFont(17);
    leftView.size = CGSizeMake(60, 48);
    _textField.leftView = leftView;
    _textField.leftViewMode = UITextFieldViewModeAlways;
    
    UILabel *rightView = [UILabel new];
    rightView.size = CGSizeMake(30, 48);
    rightView.text = @"元";
    rightView.textColor = [UIColor blackColor];
    rightView.textAlignment = NSTextAlignmentCenter;
    rightView.font = BGFont(17);
    _textField.rightView = rightView;
    _textField.rightViewMode = UITextFieldViewModeAlways;
    
    [self.view addSubview:_textField];
    
    [_textField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(0);
        make.top.mas_equalTo(10);
        make.height.mas_equalTo(48);
    }];
    
    _nextBtn = [UIButton new];
    [_nextBtn setBackgroundColor:orangeColor];
    [_nextBtn setTitle:@"下一步" forState:UIControlStateNormal];
    [_nextBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_nextBtn.titleLabel setFont:BGFont(20)];
    [_nextBtn addTarget:self action:@selector(nextPage) forControlEvents:UIControlEventTouchUpInside];
    _nextBtn.layer.cornerRadius =3;
    _nextBtn.layer.masksToBounds = YES;
    [self.view addSubview:_nextBtn];
    [_nextBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(30);
        make.right.mas_equalTo(-30);
        make.top.mas_equalTo(_textField.mas_bottom).offset(50);
        make.height.mas_equalTo(40);
    }];
}

-(void)nextPage
{
    if (_textField.text.length) {
        if ([TDUtil isPureInt:_textField.text] || [TDUtil isPureFloat:_textField.text]) {
            [self goRecharge];
        }
    }else{
        [[DialogUtil sharedInstance]showDlg:self.view textOnly:@"投资金额不能为空"];
    }
}

#pragma mark-------------------去充值----------------------
-(void)goRecharge
{
    NSString * str = [TDUtil generateUserPlatformNo];
    
    NSMutableDictionary * dic = [NSMutableDictionary new];
    _tradeCode =[TDUtil generateTradeNo];
    //    [dic setObject:[NSString stringWithFormat:@"%f",_cha] forKey:@"amount"];
    [dic setObject:str forKey:@"platformUserNo"];
    [dic setObject:@"PLATFORM" forKey:@"feeMode"];
    [dic setObject:_textField.text forKey:@"amount"];
    [dic setObject:_tradeCode forKey:@"requestNo"];
    [dic setObject:@"ios://verify" forKey:@"callbackUrl"];
    [dic setObject:notifyUrl forKey:@"notifyUrl"];
    
    NSString * signString = [TDUtil convertDictoryToYeePayXMLString:dic];
    _request = signString;
    
    [self sign:signString sel:@selector(requestRecharge:) type:0];
}

-(void)requestRecharge:(ASIHTTPRequest *)request
{
    NSString *jsonString = [TDUtil convertGBKDataToUTF8String:request.responseData];
//    NSLog(@"返回:%@",jsonString);
    NSMutableDictionary* jsonDic = [jsonString JSONValue];
    if (jsonDic != nil) {
        NSString *status = [jsonDic valueForKey:@"status"];
        if ([status integerValue] == 200) {
            NSDictionary * data = [jsonDic valueForKey:@"data"];
            NSDictionary * dic = [NSDictionary dictionaryWithObjectsAndKeys:_request,@"req",[data valueForKey:@"sign"],@"sign", nil];
            YeePayViewController * controller = [[YeePayViewController alloc]init];
            controller.title = @"充值";
            controller.dic = [NSMutableDictionary new];
            controller.PostPramDic = dic;
            //            controller.startPageImage = self.startPageImage;
//            controller.abbrevName =self.abbrevName;
//            controller.fullName = self.fullName;
//            //            NSString* mount =_textField.text;
//            [controller.dic setValue:self.profit forKey:@"profit"];
//            [controller.dic setValue:self.abbrevName forKey:@"abbrevName"];
//            [controller.dic setValue:self.fullName forKey:@"fullName"];
//            [controller.dic setValue:self.borrowerUserNumber forKey:@"borrower_user_no"];
            //            [controller.dic setValue:[NSString stringWithFormat:@"%ld",self.projectId] forKey:@"projectId"];
            
            //            [controller.dic setValue:mount forKey:@"mount"];
            
            //            [controller.dic setValue:_flagArray[0] forKey:@"currentSelect"];
            controller.tradeCode = _tradeCode;
            controller.state = PayStatusAccount;
            
            controller.url = [NSURL URLWithString:STRING_3(@"%@%@",BUINESS_SERVER,YeePayMent,nil)];
            
            [self.navigationController pushViewController:controller animated:YES];
        }
    }
}

-(void)sign:(NSString*)signString sel:(SEL)sel type:(int)type
{
    [self.httpUtil getDataFromAPIWithOps:YEEPAYSIGNVERIFY postParam:[NSDictionary dictionaryWithObjectsAndKeys:KEY,@"key",self.signPartner,@"partner",signString,@"req",@"sign",@"method",@"",@"sign",STRING(@"%d", type),@"type",nil] type:0 delegate:self sel:sel];
}

#pragma mark -------------------------textFiledDelegate-----------------------------
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return NO;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField{
    
    
    NSLog(@"开始编辑");
}

- (void)textFieldDidEndEditing:(UITextField *)textField{
    
    if (![textField.text isEqualToString:@""]) {
        
        _textField.text = textField.text;
    }
    NSLog(@"结束编辑");
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
