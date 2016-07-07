//
//  ResetPassWordViewController.m
//  JinZhiT
//
//  Created by Eugene on 16/5/5.
//  Copyright © 2016年 Eugene. All rights reserved.
//

#import "ResetPassWordViewController.h"

#define RESET @"resetPassWordUser"

@interface ResetPassWordViewController ()<UITextFieldDelegate>
{
    UIActivityIndicatorView* activity;
}

@property (weak, nonatomic) IBOutlet UIButton *certainBtn;
@property (weak, nonatomic) IBOutlet UITextField *firstTextField;
@property (weak, nonatomic) IBOutlet UITextField *secondField;

@end

@implementation ResetPassWordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self createUI];
    NSString * string = [AES encrypt:RESET password:KEY];
    self.partner = [TDUtil encryptMD5String:string];
    //    NSLog(@"%@",_partner);
    
}

-(void)createUI{
    //确定按钮的属性
    _certainBtn.layer.cornerRadius = 20;
    _certainBtn.layer.masksToBounds = YES;
    _certainBtn.layer.borderWidth = 1;
    _certainBtn.layer.borderColor = [[UIColor whiteColor] CGColor];
}
//返回按钮
- (IBAction)leftBackBtn:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
//确定按钮
- (IBAction)certainBtn:(UIButton *)sender {
    
    [self.firstTextField resignFirstResponder];
    [self.secondField resignFirstResponder];
    NSString *password = self.firstTextField.text;
    NSString *passwordRepeat = self.secondField.text;
    
    if (!password || [password isEqualToString:@""]) {
        [[DialogUtil sharedInstance]showDlg:self.view textOnly:@"请输入密码"];
        return ;
    }
    
    if (!passwordRepeat || [passwordRepeat isEqualToString:@""]) {
        [[DialogUtil sharedInstance]showDlg:self.view textOnly:@"请再次输入密码"];
        return ;
    }
    
    if ([passwordRepeat intValue]!=[password intValue]) {
        [[DialogUtil sharedInstance]showDlg:self.view textOnly:@"两次密码输入不一致"];
        return ;
    }
    //加密
    password = [TDUtil encryptPhoneNumWithMD5:self.telephone passString:password];
    
    NSDictionary *dic = [[NSDictionary alloc]initWithObjectsAndKeys:KEY,@"key",self.partner,@"partner",self.telephone,@"telephone",password,@"password",self.certifyNum,@"verifyCode",PLATFORM,@"platform",nil];
    
    //加载动画
    //加载动画控件
    if (!activity) {
        //进度
        activity = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(WIDTH(self.certainBtn)/3-18, HEIGHT(self.certainBtn)/2-15, 30, 30)];//指定进度轮的大小
        [activity setActivityIndicatorViewStyle:UIActivityIndicatorViewStyleWhite];//设置进度轮显示类型
        [self.certainBtn addSubview:activity];
    }else{
        if (!activity.isAnimating) {
            [activity startAnimating];
        }
    }
    [activity setColor:WriteColor];
    
    //开始加载动画
    [activity startAnimating];
    
    [self.httpUtil getDataFromAPIWithOps:USER_FORGET_PWD postParam:dic type:0 delegate:self sel:@selector(requestRestPass:)];
}

//重置密码
-(void)requestRestPass:(ASIHTTPRequest *)request
{
    NSString *jsonString = [TDUtil convertGBKDataToUTF8String:request.responseData];
//    NSLog(@"返回:%@",jsonString);
    NSMutableDictionary* jsonDic = [jsonString JSONValue];
    if (jsonDic!=nil) {
        NSString *status = [jsonDic valueForKey:@"status"];
        if ([status integerValue] == 200) {
            [[DialogUtil sharedInstance]showDlg:self.view textOnly:[jsonDic valueForKey:@"message"]];

            NSUserDefaults* data =[NSUserDefaults standardUserDefaults];
            [data setValue:@"YES" forKey:@"isLogin"];
            [data setValue:@"NO" forKey:@"isAnimous"];
            NSString* phoneNumber = self.telephone;
            NSString* password =self.firstTextField.text;
            password = [TDUtil encryptPhoneNumWithMD5:phoneNumber passString:password];
            
            [data setValue:phoneNumber forKey:STATIC_USER_DEFAULT_DISPATCH_PHONE];
            [data setValue:password forKey:STATIC_USER_PASSWORD];
            
            [data setValue:[jsonDic[@"data"] valueForKey:@"userId"] forKey:USER_STATIC_USER_ID];
            [data setValue:[jsonDic[@"data"] valueForKey:@"extUserId"] forKey:USER_STATIC_EXT_USER_ID];
            
            //进入主界面
            AppDelegate * app =(AppDelegate* )[[UIApplication sharedApplication] delegate];
            app.window.rootViewController = app.tabBar;
            
            
        }else{
            [[DialogUtil sharedInstance]showDlg:self.view textOnly:[jsonDic valueForKey:@"message"]];

        }
        
    }
    [activity stopAnimating];
}

-(void)requestFailed:(ASIHTTPRequest *)request
{
    [activity stopAnimating];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    // 禁用 iOS7 返回手势
    if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        if (!self.navigationController.interactivePopGestureRecognizer.enabled) {
            self.navigationController.interactivePopGestureRecognizer.enabled = YES;
        }
        
    }
}
@end
