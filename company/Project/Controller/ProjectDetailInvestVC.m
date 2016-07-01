//
//  ProjectDetailInvestVC.m
//  JinZhiT
//
//  Created by Eugene on 16/6/2.
//  Copyright © 2016年 Eugene. All rights reserved.
//

#import "ProjectDetailInvestVC.h"

#import "YeePayViewController.h"


#define SIGNVERIFY @"signVerify"
#define INVESTPROJECT @"requestInvestProject"
@interface ProjectDetailInvestVC ()<UITextFieldDelegate>
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
}

-(void)setNav
{
    self.navigationItem.title = @"认投项目";
    UIButton * leftback = [UIButton buttonWithType:UIButtonTypeCustom];
    [leftback setImage:[UIImage imageNamed:@"leftBack"] forState:UIControlStateNormal];
    [leftback addTarget:self action:@selector(leftback) forControlEvents:UIControlEventTouchUpInside];
    leftback.size = CGSizeMake(32, 20);
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
    
//    _btnView = [UIView new];
//    _btnView.backgroundColor = orangeColor;
//    [self.view addSubview:_btnView];
//    _btnView.sd_layout
//    .leftSpaceToView(_textField,0)
//    .topSpaceToView(remindLabel,9)
//    .widthIs(48)
//    .heightIs(44);
    
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

#pragma mark-------------------------btnClickAction--------------------------------
-(void)leftback
{
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
                if ([_textField.text floatValue] < _limitAmount) {
                    [[DialogUtil sharedInstance]showDlg:self.view textOnly:[NSString stringWithFormat:@"投资金额不能少于%f",_limitAmount]];
                    return;
                }
#pragma mark----------------------进入易宝流程-------------------------
//                NSLog(@"立即支付-----%f",_limitAmount);
                
                
                [self isCheckUserConfirmed];
                
            }else{
            [[DialogUtil sharedInstance]showDlg:self.view textOnly:@"请输入正确的投资金额"];
            }
            
        }else{
        [[DialogUtil sharedInstance]showDlg:self.view textOnly:@"投资金额不能为空"];
        }
    }
    
    btn.selected = !btn.selected;
    
    NSLog(@"打印领投还是跟投标识---%@",_flagArray[0]);
}
#pragma mark ----------认证是否是易宝用户-------------
-(void)isCheckUserConfirmed
{
    NSString * str = [TDUtil generateUserPlatformNo];
    
    NSMutableDictionary * dic = [NSMutableDictionary new];
    [dic setObject:str forKey:@"platformUserNo"];
    
    NSString * signString = [TDUtil convertDictoryToYeePayXMLString:dic];
    _request = signString;
    
    [self sign:signString sel:@selector(requestCheckUserSign:) type:1];
    
}

-(void)requestCheckUserSign:(ASIHTTPRequest *)request{
    NSString *jsonString = [TDUtil convertGBKDataToUTF8String:request.responseData];
//    NSLog(@"返回:%@",jsonString);
    NSMutableDictionary* jsonDic = [jsonString JSONValue];
    
    if(jsonDic!=nil)
    {
        NSString* status = [jsonDic valueForKey:@"status"];
        if ([status intValue] == 200) {
            NSDictionary * data = [jsonDic valueForKey:@"data"];
            NSDictionary * dic = [NSDictionary dictionaryWithObjectsAndKeys:_request,@"req",[data valueForKey:@"sign"],@"sign",ACCOUNT_INFO,@"service", nil];
            [self.httpUtil getDataFromYeePayAPIWithOps:@"" postParam:dic type:0 delegate:self sel:@selector(requestCheckUser:)];
        }
        
    }
}

-(void)requestCheckUser:(ASIHTTPRequest *)request{
    NSString *xmlString = [TDUtil convertGBKDataToUTF8String:request.responseData];
//    NSLog(@"返回:%@",xmlString);
    NSDictionary * xmlDic = [TDUtil convertXMLStringElementToDictory:xmlString];
    
    NSLog(@"%@",xmlDic);
    
    if ([DICVFK(xmlDic, @"code") intValue]==101) {
        [self goConfirm];
    }else if([DICVFK(xmlDic, @"code") intValue]==1)
    {
#pragma mark-------------判断余额是否足够--------------
        if ([DICVFK(xmlDic, @"availableAmount") floatValue] >= [_textField.text floatValue] * 10000) {
            payStatus = PayStatusTransfer;
            [self goInvest];
        }else{
        //去充值账户
            payStatus = PayStatusPayfor;
            CGFloat availableAmount = [DICVFK(xmlDic, @"availableAmount") floatValue];
            CGFloat inputAmount = [_textField.text floatValue] * 10000 ;
            
            CGFloat chaAmount = inputAmount - availableAmount;
            _cha = chaAmount;
//            [[DialogUtil sharedInstance]showDlg:self.view textOnly:[NSString stringWithFormat:@"账户余额不足，还差%f元，前往充值页面",chaAmount]];
            
            [self performSelector:@selector(goRecharge) withObject:nil afterDelay:2];
            
            
        }
        
    }else{
        self.isNetRequestError = YES;
    }
}


#pragma mark ----------------易宝用户认证--------------------
-(void)goConfirm
{
    NSUserDefaults * data = [NSUserDefaults standardUserDefaults];
    NSString * str = [TDUtil generateUserPlatformNo];
    
    NSMutableDictionary * dic = [NSMutableDictionary new];
    [dic setObject:str forKey:@"platformUserNo"];
    [dic setObject:[TDUtil generateTradeNo] forKey:@"requestNo"];
    [dic setObject:@"G2_IDCARD" forKey:@"idCardType"];
    [dic setObject:@"ios://verify:" forKey:@"callbackUrl"];
    
    [dic setObject:[data valueForKey:USER_STATIC_TEL]forKey:@"mobile"];
    [dic setObject:[data valueForKey:USER_STATIC_NAME] forKey:@"realName"];
    [dic setObject:[data valueForKey:USER_STATIC_IDNUMBER] forKey:@"idCardNo"];
    
    [dic setObject:notifyUrl forKey:@"notifyUrl"];
//    [dic setObject:[data valueForKey:USER_STATIC_NICKNAME] forKey:@"nickName"];
    
    
    NSString * signString = [TDUtil convertDictoryToYeePayXMLString:dic];
    _request = signString;
    [self sign:signString sel:@selector(requestSign:) type:0];
    
}

-(void)requestSign:(ASIHTTPRequest *)request{
    NSString *jsonString = [TDUtil convertGBKDataToUTF8String:request.responseData];
//    NSLog(@"返回:%@",jsonString);
    NSMutableDictionary* jsonDic = [jsonString JSONValue];
    
    if(jsonDic!=nil)
    {
        NSString* status = [jsonDic valueForKey:@"status"];
        if ([status intValue] == 200) {
            NSDictionary * data = [jsonDic valueForKey:@"data"];
            NSDictionary * dic = [NSDictionary dictionaryWithObjectsAndKeys:_request,@"req",[data valueForKey:@"sign"],@"sign", nil];
            YeePayViewController * controller = [[YeePayViewController alloc]init];
            controller.title = @"项目详情";
            controller.titleStr = @"实名认证";
            controller.PostPramDic = dic;
            controller.startPageImage = self.startPageImage;
            controller.abbrevName =self.abbrevName;
            controller.fullName = self.fullName;
//            controller.dic = self.dic;
            controller.state = PayStatusConfirm;
//            [controller.dic setValue:STRING(@"%d", currentSelect) forKey:@"currentSelect"];
            controller.url = [NSURL URLWithString:STRING_3(@"%@%@",BUINESS_SERVER,YeePayToRegister,nil)];
            [self.navigationController pushViewController:controller animated:YES];
            self.startLoading = NO;
            return;
        }
        self.isNetRequestError = YES;
    }
}
#pragma mark ---------------------去投资-----------------
-(void)goInvest
{
    NSString * str = [TDUtil generateUserPlatformNo];
    
    NSMutableDictionary * dic = [NSMutableDictionary new];
    
    NSString* mount =_textField.text;
    float money = [mount floatValue];
    
    mount = [NSString stringWithFormat:@"%.2f",money * 10000];
    
    
    [dic setObject:mount forKey:@"amount"];
    [dic setObject:str forKey:@"platformUserNo"];
    [dic setObject:@"PLATFORM" forKey:@"feeMode"];
    [dic setObject:[TDUtil generateTradeNo] forKey:@"requestNo"];
    [dic setObject:@"ios://finialConfirm" forKey:@"callbackUrl"];
    [dic setObject:notifyUrl forKey:@"notifyUrl"];
    
    
    NSString * signString = [TDUtil convertDictoryToYeePayXMLString:dic];
    _request = signString;
    [self sign:signString sel:@selector(requestSignFinial:) type:0];
}


-(void)requestSignFinial:(ASIHTTPRequest *)request{
    NSString *jsonString = [TDUtil convertGBKDataToUTF8String:request.responseData];
//    NSLog(@"返回:%@",jsonString);
    NSMutableDictionary* jsonDic = [jsonString JSONValue];
    
    if(jsonDic!=nil)
    {
        NSString* status = [jsonDic valueForKey:@"status"];
        if ([status intValue] == 200) {
            NSDictionary * data = [jsonDic valueForKey:@"data"];
            NSDictionary * dic = [NSDictionary dictionaryWithObjectsAndKeys:_request,@"req",[data valueForKey:@"sign"],@"sign", nil];
            YeePayViewController * controller = [[YeePayViewController alloc]init];
            controller.title = @"投标";
            controller.state = payStatus;
            controller.titleStr = @"易宝支付";
            controller.PostPramDic = dic;
            controller.startPageImage = self.startPageImage;
            controller.abbrevName =self.abbrevName;
            controller.fullName = self.fullName;
//            controller.dic = self.dic;
            controller.dic = [NSMutableDictionary new];
            NSString* mount =_textField.text;
            
            [controller.dic setValue:self.profit forKey:@"profit"];
            [controller.dic setValue:self.abbrevName forKey:@"abbrevName"];
            [controller.dic setValue:self.fullName forKey:@"fullName"];
            [controller.dic setValue:self.borrowerUserNumber forKey:@"borrower_user_no"];
            [controller.dic setValue:[NSString stringWithFormat:@"%ld",(long)self.projectId] forKey:@"projectId"];
            
            [controller.dic setValue:mount forKey:@"mount"];
            
            [controller.dic setValue:_flagArray[0] forKey:@"currentSelect"];
            if (payStatus == PayStatusPayfor) {
                controller.url = [NSURL URLWithString:STRING_3(@"%@%@",BUINESS_SERVER,YeePayMent,nil)];
            }
            
            [self.navigationController pushViewController:controller animated:YES];
            
        }
        
    }
}
#pragma mark-------------------去充值----------------------
-(void)goRecharge
{
    NSString * str = [TDUtil generateUserPlatformNo];
    
    NSMutableDictionary * dic = [NSMutableDictionary new];
    
    [dic setObject:[NSString stringWithFormat:@"%f",_cha] forKey:@"amount"];
    [dic setObject:str forKey:@"platformUserNo"];
    [dic setObject:@"PLATFORM" forKey:@"feeMode"];
    [dic setObject:[TDUtil generateTradeNo] forKey:@"requestNo"];
    [dic setObject:@"ios://finialConfirm" forKey:@"callbackUrl"];
    [dic setObject:notifyUrl forKey:@"notifyUrl"];
    
    NSString * signString = [TDUtil convertDictoryToYeePayXMLString:dic];
    _request = signString;
    
    [self sign:signString sel:@selector(requestRecharge:) type:0];
}

-(void)requestRecharge:(ASIHTTPRequest *)request
{
    NSString *jsonString = [TDUtil convertGBKDataToUTF8String:request.responseData];
    NSLog(@"返回:%@",jsonString);
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
            controller.startPageImage = self.startPageImage;
            controller.abbrevName =self.abbrevName;
            controller.fullName = self.fullName;
            NSString* mount =_textField.text;
            [controller.dic setValue:self.profit forKey:@"profit"];
            [controller.dic setValue:self.abbrevName forKey:@"abbrevName"];
            [controller.dic setValue:self.fullName forKey:@"fullName"];
            [controller.dic setValue:self.borrowerUserNumber forKey:@"borrower_user_no"];
            [controller.dic setValue:[NSString stringWithFormat:@"%ld",(long)self.projectId] forKey:@"projectId"];
            
            [controller.dic setValue:mount forKey:@"mount"];
            
            [controller.dic setValue:_flagArray[0] forKey:@"currentSelect"];
            
            controller.state = PayStatusPayfor;
            
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

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    //隐藏tabbar
    AppDelegate * delegate =(AppDelegate*)[UIApplication sharedApplication].delegate;
    
    [delegate.tabBar tabBarHidden:YES animated:NO];
}
@end
