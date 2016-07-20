//
//  FindPassWordViewController.m
//  JinZhiT
//
//  Created by Eugene on 16/5/5.
//  Copyright © 2016年 Eugene. All rights reserved.
//

#import "FindPassWordViewController.h"
#import "ResetPassWordViewController.h"
#import "JKCountDownButton.h"
#define FORGET @"resetPassWordUser"
@interface FindPassWordViewController ()<UITextFieldDelegate>
{
    UIActivityIndicatorView* activity;

}
@property(assign,nonatomic) BOOL isCountDown;

@property (weak, nonatomic) IBOutlet UIButton *nextStup;//下一步btn
@property (weak, nonatomic) IBOutlet JKCountDownButton *getVerifyBtn;

@property (weak, nonatomic) IBOutlet UITextField *phoneTextField;//手机号textField
@property (weak, nonatomic) IBOutlet UITextField *verifyTextField;//验证码textField

@end

@implementation FindPassWordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self createUI];
    
    NSString * string = [AES encrypt:FORGET password:KEY];
    self.partner = [TDUtil encryptMD5String:string];
    //    NSLog(@"%@",_partner);
    
    __block FindPassWordViewController * cSelf = self;
    [_getVerifyBtn addToucheHandler:^(JKCountDownButton*sender, NSInteger tag) {
        
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
                return @"点击重新获取";
                
            }];
        }
    }];
    
}

-(void)createUI{
    _nextStup.layer.cornerRadius = 20;
    _nextStup.layer.masksToBounds = YES;
    _nextStup.layer.borderColor = [[UIColor whiteColor] CGColor];
    _nextStup.layer.borderWidth = 1;
    
    _getVerifyBtn.layer.cornerRadius = 2;
    _getVerifyBtn.layer.masksToBounds = YES;
}
//获取验证码
- (IBAction)getVerify:(UIButton *)sender {
    
    [self.phoneTextField resignFirstResponder];
    NSString *phoneNumber = self.phoneTextField.text;
    
    if (phoneNumber) {
        if ([TDUtil validateMobile:phoneNumber]) {
            NSString *serverUrl = SEND_MESSAGE_CODE;
            NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:KEY,@"key",self.partner, @"partner",phoneNumber,@"telephone",PLATFORM,@"platform",FORGET_TYPE,@"type",nil];
            
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
//    NSLog(@"返回:%@",jsonString);
    NSMutableDictionary* jsonDic = [jsonString JSONValue];
    
    if(jsonDic!=nil)
    {
        NSString* code = [jsonDic valueForKey:@"status"];
        if ([code intValue] == 200) {
            [[DialogUtil sharedInstance]showDlg:self.view textOnly:[jsonDic valueForKey:@"message"]];
        }else{
            [[DialogUtil sharedInstance]showDlg:self.view textOnly:[jsonDic valueForKey:@"message"]];
        }
    }
}

//返回上一页
- (IBAction)leftBackBtn:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
//下一步
- (IBAction)nextStup:(id)sender {
    
    [self.phoneTextField resignFirstResponder];
    [self.verifyTextField resignFirstResponder];
    
    NSString *phoneNum =  self.phoneTextField.text;
    NSString *certifyNum =  self.verifyTextField.text;
    
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
    
    ResetPassWordViewController * reset = [ResetPassWordViewController new];
    reset.telephone = self.phoneTextField.text;
    reset.certifyNum = self.verifyTextField.text;
    [self.navigationController pushViewController:reset animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
