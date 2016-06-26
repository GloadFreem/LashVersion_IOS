//
//  AppSetChangePhoneVC.m
//  JinZhiT
//
//  Created by Eugene on 16/5/25.
//  Copyright © 2016年 Eugene. All rights reserved.
//

#import "AppSetChangePhoneVC.h"

#define YANZHENG @"verifyCode"
#import "JKCountDownButton.h"
#define CHANGETELEPHONE @"requestChangeBindTelephone"
@interface AppSetChangePhoneVC ()
@property(assign,nonatomic) BOOL isCountDown;

@property (weak, nonatomic) IBOutlet UITextField *phoneTextField;

@property (weak, nonatomic) IBOutlet UITextField *certainCodeText;

@property (weak, nonatomic) IBOutlet UITextField *oldPhoneText;

@property (weak, nonatomic) IBOutlet UITextField *identifyNumText;
@property (weak, nonatomic) IBOutlet JKCountDownButton *certifyCodeBtn;
@property (weak, nonatomic) IBOutlet UIButton *certainBtn;

@property (nonatomic, copy) NSString *codePartner;
@property (nonatomic, copy) NSString *phoneNumber;
@end

@implementation AppSetChangePhoneVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    //获得partner
    self.partner = [TDUtil encryKeyWithMD5:KEY action:CHANGETELEPHONE];
    _codePartner = [TDUtil encryKeyWithMD5:KEY action:YANZHENG];
    
    //拿到手机号码
    NSUserDefaults* data =[NSUserDefaults standardUserDefaults];
    _phoneNumber = [data objectForKey:STATIC_USER_DEFAULT_DISPATCH_PHONE];
    
    [self setupNav];
    
    __block AppSetChangePhoneVC * cSelf = self;
    [_certifyCodeBtn addToucheHandler:^(JKCountDownButton*sender, NSInteger tag) {
        
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

#pragma mark -设置导航栏
-(void)setupNav
{
    UIButton * leftback = [UIButton buttonWithType:UIButtonTypeCustom];
    [leftback setBackgroundImage:[UIImage imageNamed:@"leftBack"] forState:UIControlStateNormal];
    leftback.size = leftback.currentBackgroundImage.size;
    [leftback addTarget:self action:@selector(leftBack:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:leftback] ;
    self.navigationItem.title = @"更换绑定手机";
    _certifyCodeBtn.layer.cornerRadius = 3;
    _certifyCodeBtn.layer.masksToBounds = YES;
    
    _certainBtn.layer.cornerRadius = 5;
    _certainBtn.layer.masksToBounds = YES;
}
#pragma mark- 返回按钮
-(void)leftBack:(UIButton*)btn
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)getCertainCode:(UIButton *)sender {

    //元手机号判断
    if (self.oldPhoneText.text && ![self.oldPhoneText.text isEqualToString:@""]) {
        if (![self.oldPhoneText.text isEqualToString:self.phoneNumber]) {
            [[DialogUtil sharedInstance]showDlg:self.view textOnly:@"原手机号码不正确"];
            return;
        }
        
    }else{
        [[DialogUtil sharedInstance]showDlg:self.view textOnly:@"请输入原手机号码"];
        return;
    }
    //新手机号判断
    if (self.phoneTextField.text && ![self.phoneTextField.text isEqualToString:@""]) {
        if (![TDUtil validateMobile:self.phoneTextField.text]) {
            [[DialogUtil sharedInstance]showDlg:self.view textOnly:@"手机号码格式不正确"];
            return ;
        }
        
    }else{
        [[DialogUtil sharedInstance]showDlg:self.view textOnly:@"请输入新手机号码"];
        return;
    }
    
    NSString *serverUrl = SEND_MESSAGE_CODE;
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:KEY,@"key",self.partner, @"partner",self.phoneTextField.text,@"telephone",PLATFORM,@"platform",REGIST_TYPE,@"type",nil];
    
    [self.httpUtil getDataFromAPIWithOps:serverUrl postParam:dic type:0 delegate:self sel:@selector(requestSendeCode:)];
}

//发送验证码
-(void)requestSendeCode:(ASIHTTPRequest *)request{
    NSString *jsonString = [TDUtil convertGBKDataToUTF8String:request.responseData];
    NSLog(@"返回:%@",jsonString);
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

- (IBAction)certainBtnClick:(UIButton *)sender {
    
    if (!self.certainCodeText.text || [self.certainCodeText.text isEqualToString:@""]) {
        [[DialogUtil sharedInstance]showDlg:self.view textOnly:@"请输入验证码"];
        return;
    }
//    if (self.identifyNumText.text && ![self.identifyNumText.text isEqualToString:@""]) {
//        if (self.identifyNumText.text.length != 18) {
//        [[DialogUtil sharedInstance]showDlg:self.view textOnly:@"请检查身份证号码"];
//        return;
//        }
//        
//    }else{
//        [[DialogUtil sharedInstance]showDlg:self.view textOnly:@"请输入身份证号码"];
//        return;
//    }
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:KEY,@"key",self.partner,@"partner",self.phoneTextField.text,@"telephone",self.certainCodeText.text,@"code", nil];
    
    [self.httpUtil getDataFromAPIWithOps:CHANGEBINDTELEPHONE postParam:dic type:0 delegate:self sel:@selector(requestChangePhone:)];
}
-(void)requestChangePhone:(ASIHTTPRequest *)request{
    NSString *jsonString = [TDUtil convertGBKDataToUTF8String:request.responseData];
    NSLog(@"返回:%@",jsonString);
    NSMutableDictionary* jsonDic = [jsonString JSONValue];
    if(jsonDic!=nil)
    {
        NSString* code = [jsonDic valueForKey:@"status"];
        if ([code intValue] == 200) {
            [[DialogUtil sharedInstance]showDlg:self.view textOnly:[jsonDic valueForKey:@"message"]];
            [self.navigationController popViewControllerAnimated:YES];
        }else{
            [[DialogUtil sharedInstance]showDlg:self.view textOnly:[jsonDic valueForKey:@"message"]];
        }
    }
}
@end
