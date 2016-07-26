//
//  PhoneCerityViewController.m
//  JinZhiT
//
//  Created by Eugene on 16/5/7.
//  Copyright © 2016年 Eugene. All rights reserved.
//

#import "PhoneCerityViewController.h"
#import "WSetPassWordViewController.h"
#import "LoginRegistViewController.h"
#import "PingTaiWebViewController.h"

#define USERPROTOCOL @"requestUserProtocol"
#define YANZHENG @"verifyCode"

@interface PhoneCerityViewController ()<UITextFieldDelegate>
{
    dispatch_source_t _timer;
}
@property(assign,nonatomic) BOOL isCountDown;
@property (nonatomic, copy) NSString *protocolPartner;
@property (nonatomic, copy) NSString *protocolUrl;
@end

@implementation PhoneCerityViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    _certifyBtn.layer.cornerRadius = 5;
    _certifyBtn.layer.masksToBounds = YES;
    
    _nextStepBtn.layer.cornerRadius = 22;
    _nextStepBtn.layer.masksToBounds = 5;
    
    _selectedBtn.selected = YES;
    
    self.protocolPartner = [TDUtil encryKeyWithMD5:KEY action:USERPROTOCOL];
    
    [self loadProtocol];
    
    NSString * string = [AES encrypt:YANZHENG password:KEY];
    self.partner = [TDUtil encryptMD5String:string];
    //    NSLog(@"%@",_partner);
    
    __block PhoneCerityViewController * cSelf = self;
    [_certifyBtn addToucheHandler:^(JKCountDownButton*sender, NSInteger tag) {
        
        NSString* phoneNumber = cSelf.phoneTextField.text;
        if ([TDUtil isValidString:phoneNumber]) {
            if ([TDUtil validateMobile:phoneNumber]) {
                cSelf.isCountDown = YES;
            }
        }
        if (cSelf.isCountDown) {
            sender.enabled = NO;
            [sender startWithSecond:60];
            
            [sender didChange:^NSString *(JKCountDownButton *countDownButton,int second) {
                NSString *title = [NSString stringWithFormat:@"剩余%d秒",second];
                return title;
            }];
            [sender didFinished:^NSString *(JKCountDownButton *countDownButton, int second) {
                countDownButton.enabled = YES;
                return @"重新获取";
                
            }];
        }
    }];
    
}

-(void)loadProtocol
{
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:KEY,@"key",self.protocolPartner,@"partner", nil];
    //开始请求
    [self.httpUtil getDataFromAPIWithOps:REQUESTUSERPROTOCOL postParam:dic type:0 delegate:self sel:@selector(requestProtocol:)];
}
-(void)requestProtocol:(ASIHTTPRequest *)request
{
    NSString *jsonString = [TDUtil convertGBKDataToUTF8String:request.responseData];
    //        NSLog(@"返回:%@",jsonString);
    NSMutableDictionary* jsonDic = [jsonString JSONValue];
    if (jsonDic != nil) {
        NSString *status = [jsonDic valueForKey:@"status"];
        if ([status integerValue] == 200) {
            NSDictionary *dic = [jsonDic valueForKey:@"data"];
            _protocolUrl = dic[@"url"];
        }
    }
}

#pragma mark---返回上一页
- (IBAction)leftBack:(UIButton *)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
#pragma mark---下一步---
- (IBAction)nextStup:(UIButton *)sender {
    
    [self.phoneTextField resignFirstResponder];
    [self.certifyCodeTextField resignFirstResponder];
    [self.ringCodeTextField resignFirstResponder];
    
    NSString *phoneNum =  self.phoneTextField.text;
    NSString *certifyNum =  self.certifyCodeTextField.text;
    NSString *ringNum = self.ringCodeTextField.text;
    if (phoneNum && ![phoneNum isEqualToString:@""]) {
        if (![TDUtil validateMobile:phoneNum]) {
            [[DialogUtil sharedInstance]showDlg:self.view textOnly:@"手机号码格式不正确"];
            return ;
        }
    }else{
        [[DialogUtil sharedInstance]showDlg:self.view textOnly:@"请输入手机号码"];
        return ;
    }
    
    if (!certifyNum || [certifyNum isEqualToString:@""]) {
        [[DialogUtil sharedInstance] showDlg:self.view textOnly:@"请输入验证码"];
        return;
    }
    if (!_ringCodeTextField.text.length) {
        ringNum = @"";
    }
    if (!_selectedBtn.selected) {
        [[DialogUtil sharedInstance] showDlg:self.view textOnly:@"请先阅读用户协议"];
        return;
    }
    
    WSetPassWordViewController *passwordVC = [WSetPassWordViewController new];
    passwordVC.telephone = phoneNum;
    passwordVC.certifyNum = certifyNum;
    passwordVC.ringCode = ringNum;
    passwordVC.identifyType = self.identifyType;
    [self.navigationController pushViewController:passwordVC animated:YES];
}
#pragma mark---发送验证码---
- (IBAction)sendMessage:(JKCountDownButton *)sender {
    
    [_phoneTextField resignFirstResponder];
    NSString *phoneNumber = _phoneTextField.text;
    
    if (phoneNumber) {
        if ([TDUtil validateMobile:phoneNumber]) {
            NSString *serverUrl = SEND_MESSAGE_CODE;
            NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:KEY,@"key",self.partner, @"partner",phoneNumber,@"telephone",PLATFORM,@"platform",CERTIFY_TYPE,@"type",nil];
            
            [self.httpUtil getDataFromAPIWithOps:serverUrl postParam:dic type:0 delegate:self sel:@selector(requestSendeCode:)];
            //            [self startTime];
            
        }else{
            [[DialogUtil sharedInstance]showDlg:self.view textOnly:@"手机号码格式不正确"];
        }
    }else{
        [[DialogUtil sharedInstance]showDlg:self.view textOnly:@"手机号码不能为空"];
    }
}

//发送验证码
-(void)requestSendeCode:(ASIHTTPRequest *)request{
    NSString *jsonString = [TDUtil convertGBKDataToUTF8String:request.responseData];
//        NSLog(@"返回:%@",jsonString);
    NSMutableDictionary* jsonDic = [jsonString JSONValue];
    
    if(jsonDic!=nil)
    {
        NSString* code = [jsonDic valueForKey:@"status"];
        if ([code intValue] == 200) {
            
            [self.certifyBtn stop];
            [self.certifyBtn setTitle:@"获取验证码" forState:UIControlStateNormal];
            
            [[DialogUtil sharedInstance]showDlg:self.view textOnly:[jsonDic valueForKey:@"message"]];
        }else{
            
            [self.certifyBtn stop];
            [self.certifyBtn setTitle:@"获取验证码" forState:UIControlStateNormal];
            
            NSDictionary *dataDic = [NSDictionary dictionaryWithDictionary:jsonDic[@"data"]];
            BOOL isRelogin =(BOOL)dataDic[@"isRelogin"];
            if (isRelogin) {
                
                UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"温馨提示" message:@"该手机号已注册，请直接登录！" preferredStyle:UIAlertControllerStyleAlert];
                __block PhoneCerityViewController* blockSelf = self;
                
                UIAlertAction *cancleAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
                    
                }];
                UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
                    [blockSelf btnCertain:nil];
                }];
                
                [alertController addAction:cancleAction];
                [alertController addAction:okAction];
                
                [self presentViewController:alertController animated:YES completion:nil];

                
            }else{
            [[DialogUtil sharedInstance]showDlg:self.view textOnly:[jsonDic valueForKey:@"message"]];
            }
        }
    }
}
-(void)btnCertain:(id)sender
{
    LoginRegistViewController * login;
    for (UIViewController *vc in self.navigationController.viewControllers) {
        if ([vc isKindOfClass:LoginRegistViewController.class]) {
            login = (LoginRegistViewController*)vc;
        }else{
            [vc removeFromParentViewController];
        }
    }
    
    if(!login)
    {
        login = [[LoginRegistViewController alloc]init];
    }
    
    [self.navigationController pushViewController:login animated:NO];
    

}

- (IBAction)selectedBtnClick:(UIButton *)sender {
    sender.selected = !sender.selected;
}


- (IBAction)protocolBtnClick:(UIButton *)sender {
    PingTaiWebViewController *vc = [PingTaiWebViewController new];
    vc.url = _protocolUrl;
    vc.titleStr = @"用户协议";
    [self.navigationController pushViewController:vc animated:YES];
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
