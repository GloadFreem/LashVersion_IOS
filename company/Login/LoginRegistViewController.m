//
//  LoginRegistViewController.m
//  JinZhiT
//
//  Created by Eugene on 16/5/4.
//  Copyright © 2016年 Eugene. All rights reserved.
//

#import "LoginRegistViewController.h"
#import "RegisterViewController.h"
#import "FindPassWordViewController.h"
#import "PerfectViewController.h"
#import "RenzhengViewController.h"
#import "ProjectViewController.h"
#import "MyNavViewController.h"
#import "InvestViewController.h"
#import "ActivityViewController.h"
#import "MineViewController.h"
#import "CircleViewController.h"
#import "JTabBarController.h"

#define WELOGINUSER @"wechatLoginUser"
#define DENGLU @"loginUser"
#define CUSTOMSERVICE @"customServiceSystem"

@interface LoginRegistViewController ()
{
    UIActivityIndicatorView* activity;
    NSString* openId;
    NSString *_password;
}

@property (weak, nonatomic) IBOutlet UIButton *iconBtn;

@property (weak, nonatomic) IBOutlet UIButton *loginBtn;

@property (weak, nonatomic) IBOutlet UIButton *noBtn;
@property (weak, nonatomic) IBOutlet UIButton *forgetBtn;
@property (weak, nonatomic) IBOutlet UIButton *wxBtn;

@property (weak, nonatomic) IBOutlet UITextField *phoneField;
@property (weak, nonatomic) IBOutlet UITextField *passwordField;

@property (nonatomic, copy) NSString *servicePartner;
@property (nonatomic, copy) NSString *servicePhone;

@property (nonatomic, copy) NSString *wePartner;

@property (nonatomic, copy) NSString *wePic;
@property (nonatomic, copy) NSString *weToken;

@property (strong, nonatomic) UINavigationController * nav;
@end

@implementation LoginRegistViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self createUI];
    
    NSString * string = [AES encrypt:DENGLU password:KEY];
    self.partner = [TDUtil encryptMD5String:string];
    //    NSLog(@"%@",_partner);
    //客服
    self.servicePartner = [TDUtil encryKeyWithMD5:KEY action:CUSTOMSERVICE];
    self.wePartner = [TDUtil encryKeyWithMD5:KEY action:WELOGINUSER];
    
    //加载本地默认数据
    [self loadDefaultData];
    
}

-(void)loadDefaultData
{
    NSUserDefaults * data = [NSUserDefaults standardUserDefaults];
    NSString * phoneNumber = [data valueForKey:STATIC_USER_DEFAULT_DISPATCH_PHONE];
    if (phoneNumber) {
        self.phoneField.text = phoneNumber;
    }
    
}

-(void)createUI{
    //头像
    _iconBtn.layer.cornerRadius = 52;
    _iconBtn.layer.masksToBounds = YES;
    _iconBtn.layer.borderWidth = 4;
    _iconBtn.layer.borderColor = [TDUtil colorWithHexString:@"afb7bd"].CGColor;
}
//登录
- (IBAction)loginClick:(UIButton *)sender {
    
    
    [self.phoneField resignFirstResponder];
    [self.passwordField resignFirstResponder];
    
    
    if ([sender isKindOfClass:[UIButton class]]) {
        //初始化网络请求对象
        //获取数据
        NSString *phoneNumber = self.phoneField.text;
        _password  = self.passwordField.text;
        
        //校验数据
        if (phoneNumber && ![phoneNumber isEqualToString:@""]) {
            if (![TDUtil validateMobile:phoneNumber]) {
                [[DialogUtil sharedInstance]showDlg:self.view textOnly:@"请输入正确手机号码"];
                self.phoneField.text=@"";
                return ;
            }
        }else{
            [[DialogUtil sharedInstance]showDlg:self.view textOnly:@"请输入手机号码"];
            return ;
        }
        
        if (!_password || [_password isEqualToString:@""]) {
            [[DialogUtil sharedInstance]showDlg:self.view textOnly:@"请输入密码"];
            return ;
        }
        
        //加密
        _password = [TDUtil encryptPhoneNumWithMD5:phoneNumber passString:_password];
        //激光推送Id
        NSString *regId = [JPUSHService registrationID];
//        NSString *regId = @"141fe1da9ead0e753f8";
        
        NSDictionary *dic = [[NSDictionary alloc]initWithObjectsAndKeys:KEY,@"key",self.partner,@"partner",phoneNumber,@"telephone",_password,@"password",PLATFORM,@"platform", regId,@"regId",nil];
//        NSLog(@"------%@",dic);
        //加载动画
        //加载动画控件
        if (!activity) {
            //进度
            activity = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(WIDTH(self.loginBtn)/3-18, HEIGHT(self.loginBtn)/2-15, 30, 30)];//指定进度轮的大小
            [activity setActivityIndicatorViewStyle:UIActivityIndicatorViewStyleWhite];//设置进度轮显示类型
            [self.loginBtn addSubview:activity];
        }else{
            if (!activity.isAnimating) {
                [activity startAnimating];
            }
        }
        [activity setColor:WriteColor];
        
        //开始加载动画
        [activity startAnimating];
        
        //开始请求
        [self.httpUtil getDataFromAPIWithOps:USER_LOGIN postParam:dic type:0 delegate:self sel:@selector(requestLogin:)];
        
    }
}

#pragma ASIHttpRequester
//===========================================================网络请求=====================================

/**
 *  登录
 *
 *  @param request 请求实例
 */
-(void)requestLogin:(ASIHTTPRequest *)request
{
    NSString *jsonString = [TDUtil convertGBKDataToUTF8String:request.responseData];
//    NSLog(@"返回:%@",jsonString);
    NSMutableDictionary* jsonDic = [jsonString JSONValue];
    
    if (jsonDic!=nil) {
        NSString *status = [jsonDic valueForKey:@"status"];
        if ([status intValue] == 200) {

            NSDictionary *data= [jsonDic valueForKey:@"data"];
            NSDictionary *idenTypeDic = [NSDictionary dictionaryWithDictionary:[data valueForKey:@"identityType"]];
            NSString *name = idenTypeDic[@"name"];
            //            NSInteger identifyId =(NSInteger)idenTypeDic[@"identiyTypeId"];
            
            if (name && [name isEqualToString:@"无身份"]) {//去认证
                //进入身份完善信息界面
                PerfectViewController *perfert = [PerfectViewController new];
//                perfert.wxIcon = _wePic;
                [self.navigationController pushViewController:perfert animated:YES];
            }else{
                //进入应用
                AppDelegate *delegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
                
                JTabBarController * tabBarController = [[JTabBarController alloc]init];
                tabBarController.delegate = delegate;
//                tabBarController.selectedItem = 0;
                delegate.tabBar = tabBarController;
//                delegate.nav = [[UINavigationController alloc]initWithRootViewController:delegate.tabBar];
                delegate.window.rootViewController = delegate.tabBar;
                
                NSUserDefaults* data =[NSUserDefaults standardUserDefaults];
                
                [data setValue:self.phoneField.text forKey:STATIC_USER_DEFAULT_DISPATCH_PHONE];
                [data setValue:_password forKey:STATIC_USER_PASSWORD];
                
                [data setValue:[jsonDic[@"data"] valueForKey:@"userId"] forKey:USER_STATIC_USER_ID];
                [data setValue:[jsonDic[@"data"] valueForKey:@"extUserId"] forKey:USER_STATIC_EXT_USER_ID];
                
//                [self removeFromParentViewController];
            
            }
            
        }else{
            [[DialogUtil sharedInstance]showDlg:self.view textOnly:[jsonDic valueForKey:@"message"]];
         
        }
        
    }
    [activity stopAnimating];
}

/**
 *  网络请求失败
 *
 *  @param request 请求实例
 */
- (void)requestFailed:(ASIHTTPRequest *)request
{
    NSString *jsonString = [TDUtil convertGBKDataToUTF8String:request.responseData];
    NSLog(@"返回:%@",jsonString);
    self.startLoading =NO;
    [[DialogUtil sharedInstance]showDlg:self.view textOnly:@"网络请求错误"];
    [activity stopAnimating];
}
#pragma mark -没有账号
//没有账号
- (IBAction)noBtn:(id)sender {
    
    self.phoneField.text = @"";
    self.passwordField.text = @"";
    
    RegisterViewController * registerVC = [[RegisterViewController alloc]init];
    
    [self.navigationController pushViewController:registerVC animated:YES];
    
}
#pragma mark -忘记密码
//忘记密码
- (IBAction)forgetPassWord:(id)sender {
    FindPassWordViewController * find =[FindPassWordViewController new];
    [self.navigationController pushViewController:find animated:YES];
}
#pragma mark -微信登陆
- (IBAction)weChatBtn:(UIButton *)sender {
    
    UMSocialSnsPlatform *snsPlatform = [UMSocialSnsPlatformManager getSocialPlatformWithName:UMShareToWechatSession];
    
    snsPlatform.loginClickHandler(self,[UMSocialControllerService defaultControllerService],YES,^(UMSocialResponseEntity *response){
        
        if (response.responseCode == UMSResponseCodeSuccess) {
            
            self.loadingViewFrame = self.view.frame;
            self.startLoading = YES;
            self.isTransparent = YES;
            
            UMSocialAccountEntity *snsAccount = [[UMSocialAccountManager socialAccountDictionary]valueForKey:UMShareToWechatSession];
//            snsAccount.openId
            //微信授权登录
            //激光推送Id
            NSString *regId = [JPUSHService registrationID];
//            NSString *regId = @"141fe1da9ead0e753f8";
            
            _wePic = snsAccount.iconURL;
            NSUserDefaults* data =[NSUserDefaults standardUserDefaults];
            [data setValue:snsAccount.userName forKey:@"nickName"];
            [data setValue:snsAccount.openId forKey:USER_WECHAT_ID];
            [data synchronize];
            
             NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:KEY,@"key",self.wePartner,@"partner",snsAccount.openId,@"wechatID",@"1",@"platform",regId,@"regid", nil];
            
            //开始请求
            [self.httpUtil getDataFromAPIWithOps:WECHATLOGINUSER postParam:dic type:0 delegate:self sel:@selector(requestWELogin:)];
            
        }
    });
}

-(void)requestWELogin:(ASIHTTPRequest *)request
{
    NSString *jsonString = [TDUtil convertGBKDataToUTF8String:request.responseData];
//        NSLog(@"返回:%@",jsonString);
    NSMutableDictionary* jsonDic = [jsonString JSONValue];
    if (jsonDic != nil) {
        NSString *status = [jsonDic valueForKey:@"status"];
        if ([status integerValue] == 200) {
            self.startLoading = NO;
            
            NSDictionary *data= [jsonDic valueForKey:@"data"];
            NSDictionary *idenTypeDic = [NSDictionary dictionaryWithDictionary:[data valueForKey:@"identityType"]];
            NSString *name = idenTypeDic[@"name"];
//            NSInteger identifyId =(NSInteger)idenTypeDic[@"identiyTypeId"];
            NSUserDefaults* defaults =[NSUserDefaults standardUserDefaults];
            [defaults setValue:@"YES" forKey:IS_WECHAT_LOGIN];
            if (name && [name isEqualToString:@"无身份"]) {//去认证
                //进入身份完善信息界面
                PerfectViewController *perfert = [PerfectViewController new];
                perfert.wxIcon = _wePic;
                [self.navigationController pushViewController:perfert animated:YES];
            }else{
                //进入应用
                AppDelegate *delegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
                
                JTabBarController * tabBarController = [[JTabBarController alloc]init];
                tabBarController.delegate = delegate;
                delegate.tabBar = tabBarController;

                delegate.window.rootViewController = delegate.tabBar;
                
                [defaults setValue:[jsonDic[@"data"] valueForKey:@"userId"] forKey:USER_STATIC_USER_ID];
                [defaults setValue:[jsonDic[@"data"] valueForKey:@"extUserId"] forKey:USER_STATIC_EXT_USER_ID];
                
            }
            
        }else{
        self.startLoading = NO;
        [[DialogUtil sharedInstance]showDlg:self.view textOnly:[jsonDic valueForKey:@"message"]];
        }
    }
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:YES];
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    // 禁用 iOS7 返回手势
    if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        if (!self.navigationController.interactivePopGestureRecognizer.enabled) {
            self.navigationController.interactivePopGestureRecognizer.enabled = YES;
        }
    }
}

-(void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
}
-(void)dealloc
{
    
}
//让当前控制器对应的状态栏是白色
-(UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleLightContent;
}


@end
