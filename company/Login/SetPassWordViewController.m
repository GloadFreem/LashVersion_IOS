//
//  SetPassWordViewController.m
//  JinZhiT
//
//  Created by Eugene on 16/5/5.
//  Copyright © 2016年 Eugene. All rights reserved.
//

#import "SetPassWordViewController.h"
#import "PerfectViewController.h"

#define ZHUCE @"registUser"
@interface SetPassWordViewController ()
{
    UIActivityIndicatorView* activity;
}
@property (weak, nonatomic) IBOutlet UIButton *leftBackBtn;

@property (weak, nonatomic) IBOutlet UIButton *haveRegist;

@property (weak, nonatomic) IBOutlet UITextField *password;
@property (weak, nonatomic) IBOutlet UITextField *passwordRepeat;



@end

@implementation SetPassWordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self createUI];
    NSString * string = [AES encrypt:ZHUCE password:KEY];
    self.partner = [TDUtil encryptMD5String:string];
    
//    NSLog(@"partner%@",self.partner);
//    NSLog(@"%@--%@--%@",self.telephone,self.certifyNum,self.ringCode);
}

-(void)createUI{
    _haveRegist.layer.cornerRadius = 20;
    _haveRegist.layer.masksToBounds = YES;
    _haveRegist.layer.borderColor = [[UIColor whiteColor] CGColor];
    _haveRegist.layer.borderWidth = 1;
}
- (IBAction)leftBackClick:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
- (IBAction)haveRegist:(id)sender {
    
    [_password resignFirstResponder];
    [_passwordRepeat resignFirstResponder];
    
    NSString *password = _password.text;
    NSString *passwordRepeat = _passwordRepeat.text;
    
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
    //激光推送Id
    NSString *regId = [JPUSHService registrationID];
    
    
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:KEY,@"key",self.partner, @"partner",self.telephone,@"telephone",password,@"password",self.certifyNum,@"verifyCode",self.ringCode,@"inviteCode",PLATFORM,@"platform",REGIST_TYPE,@"type",regId,@"regId",nil];
    //加载动画
    //加载动画控件
    if (!activity) {
        //进度
        activity = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(WIDTH(self.haveRegist)/3-18, HEIGHT(self.haveRegist)/2-15, 30, 30)];//指定进度轮的大小
        [activity setActivityIndicatorViewStyle:UIActivityIndicatorViewStyleWhite];//设置进度轮显示类型
        [self.haveRegist addSubview:activity];
    }else{
        if (!activity.isAnimating) {
            [activity startAnimating];
        }
    }
    [activity setColor:WriteColor];
    
    //开始加载动画
    [activity startAnimating];
    NSString *serverUrl = USER_REGIST;
    [self.httpUtil getDataFromAPIWithOps:serverUrl postParam:dic type:0 delegate:self sel:@selector(requestRegiste:)];
    

    
}

//注册
-(void)requestRegiste:(ASIHTTPRequest *)request{
    NSString *jsonString = [TDUtil convertGBKDataToUTF8String:request.responseData];
//    NSLog(@"返回:%@",jsonString);
    NSMutableDictionary* jsonDic = [jsonString JSONValue];
    
    if(jsonDic!=nil)
    {
        NSString* status = [jsonDic valueForKey:@"status"];
        if ([status intValue] == 200) {
            NSUserDefaults* data =[NSUserDefaults standardUserDefaults];
            NSString* password  =self.password.text;
            password = [TDUtil encryptPhoneNumWithMD5:self.telephone passString:password];
            [data setValue:password forKey:STATIC_USER_PASSWORD];
    
//            [[DialogUtil sharedInstance]showDlg:self.view textOnly:[jsonDic valueForKey:@"message"]];
            
            //进度查看
            double delayInSeconds = 1.0;
            //__block RoadShowDetailViewController* bself = self;
            dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
            dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
                
            PerfectViewController * perfect =[PerfectViewController new];
            perfect.btnTitle = @"完成注册";
            [self.navigationController pushViewController:perfect animated:YES];
            });
            
        }else{
            NSString* msg =[jsonDic valueForKey:@"message"];
            [[DialogUtil sharedInstance]showDlg:self.view textOnly:msg];
        }
        [activity stopAnimating];
    }
    
    
}

-(void)requestFailed:(ASIHTTPRequest *)request
{
    NSString *jsonString = [TDUtil convertGBKDataToUTF8String:request.responseData];
    NSLog(@"返回:%@",jsonString);
    [activity stopAnimating];
}

-(void)back:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

//让当前控制器对应的状态栏是白色
-(UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleLightContent;
}
@end
