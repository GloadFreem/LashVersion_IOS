//
//  RegisterViewController.m
//  JinZhiT
//
//  Created by Eugene on 16/5/5.
//  Copyright © 2016年 Eugene. All rights reserved.
//

#import "RegisterViewController.h"
#import "SetPassWordViewController.h"

#define YANZHENG @"verifyCode"

#import "JKCountDownButton.h"
@interface RegisterViewController ()<UITextFieldDelegate>
{
    dispatch_source_t _timer;
}
@property(assign,nonatomic) BOOL isCountDown;

@property (weak, nonatomic) IBOutlet JKCountDownButton *sendMsgBtn;

@property (weak, nonatomic) IBOutlet UIButton *certifyBtn;
@property (weak, nonatomic) IBOutlet UIButton *selectedBtn;

@property (weak, nonatomic) IBOutlet UITextField *phoneField;

@property (weak, nonatomic) IBOutlet UITextField *certifyField;

@property (weak, nonatomic) IBOutlet UITextField *ringCodeField;

@end

@implementation RegisterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    _certifyBtn.layer.cornerRadius = 5;
    _certifyBtn.layer.masksToBounds = YES;
    
    NSString * string = [AES encrypt:YANZHENG password:KEY];
    self.partner = [TDUtil encryptMD5String:string];
//    NSLog(@"%@",_partner);
    
    __block RegisterViewController * cSelf = self;
    [_sendMsgBtn addToucheHandler:^(JKCountDownButton*sender, NSInteger tag) {
        
        NSString* phoneNumber = cSelf.phoneField.text;
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

#pragma mark --- leftBackBtn  Action
- (IBAction)leftBack:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
#pragma mark --- registBtn   Action
//注册按钮点击事件
- (IBAction)registClick:(id)sender {
    
    NSString *phoneNum =  self.phoneField.text;
    NSString *certifyNum =  self.certifyField.text;
    NSString *ringNum = self.ringCodeField.text;
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
    if (!_ringCodeField.text.length) {
        ringNum = @"";
    }
    
    SetPassWordViewController * set = [SetPassWordViewController new];
    set.telephone = phoneNum;
    set.certifyNum = certifyNum;
    set.ringCode = ringNum;
    [self.navigationController pushViewController:set animated:YES];
}
- (IBAction)sendMessage:(UIButton *)sender {
    
    
    NSString *phoneNumber = _phoneField.text;
    
    if (phoneNumber) {
        if ([TDUtil validateMobile:phoneNumber]) {
            NSString *serverUrl = SEND_MESSAGE_CODE;
            NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:KEY,@"key",self.partner, @"partner",phoneNumber,@"telephone",PLATFORM,@"platform",REGIST_TYPE,@"type",nil];
            
            [self.httpUtil getDataFromAPIWithOps:serverUrl postParam:dic type:0 delegate:self sel:@selector(requestSendeCode:)];
//            [self startTime];
            
        }else{
           [[DialogUtil sharedInstance]showDlg:self.view textOnly:@"手机号码格式不正确"];
        }
    }else{
        [[DialogUtil sharedInstance]showDlg:self.view textOnly:@"手机号码不能为空"];
    }
}

//-(void)startTime
//{
//    __block int timeout=60; //倒计时时间
//    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
//    _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0,queue);
//    dispatch_source_set_timer(_timer,dispatch_walltime(NULL, 0),1.0*NSEC_PER_SEC, 0); //每秒执行
//    dispatch_source_set_event_handler(_timer, ^{
//        if(timeout<=0){ //倒计时结束，关闭
//            dispatch_source_cancel(_timer);
//            dispatch_async(dispatch_get_main_queue(), ^{
//                //设置界面的按钮显示 根据自己需求设置
//                [_sendMsgBtn setTitle:@"获取验证码" forState:UIControlStateNormal];
//                _sendMsgBtn.userInteractionEnabled = YES;
//
//            });
//        }else{
//            int seconds = timeout;
//            NSString *strTime = [NSString stringWithFormat:@"%.2d", seconds];
//            dispatch_async(dispatch_get_main_queue(), ^{
//                //设置界面的按钮显示 根据自己需求设置
//                NSLog(@"____%@",strTime);
//                [_sendMsgBtn setTitle:[NSString stringWithFormat:@"重新获取(%@)",strTime] forState:UIControlStateNormal];
//                
//                _sendMsgBtn.userInteractionEnabled = NO;
//                
//            });
//            
//            timeout--;
//        }
//    });
//    
//    dispatch_resume(_timer);
//}
- (IBAction)selectedBtnClick:(UIButton *)sender {
    
    sender.selected = !sender.selected;
}


#pragma ASIHttpRequester
//===========================================================网络请求=====================================
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

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//让当前控制器对应的状态栏是白色
-(UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleLightContent;
}

@end
